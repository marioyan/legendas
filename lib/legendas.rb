def autenticado_como(usuario, senha)
  @agente = Mechanize.new
  @pagina_inicial = @agente.get("http://legendas.tv")
  
  form = @pagina_inicial.form_with(:action => "login_verificar.php")
  form["txtLogin"] = usuario
  form["txtSenha"] = senha

  @agente.submit(form)
  
  yield
end

def buscar(texto)
  form = @pagina_inicial.form_with(:action => "index.php?opcao=buscarlegenda")
  form["txtLegenda"] = "#{texto}"

  pagina = @agente.submit(form)

  pagina.search("#conteudodest > div > span").each do |s|
    elemento_id = s.search(".buscaDestaque", ".buscaNDestaque")
    elemento_nome = s.search(".brls")
  
    id = elemento_id.attr("onclick").text
    id = id.gsub(/(javascript|abredown|[^a-zA-Z0-9])/,"")
    
    nome = elemento_nome.text
  
    yield id, nome
  end
end

def baixar(id)
  arquivo = @agente.get("http://legendas.tv/info.php?d=#{id}&c=1")
  
  yield arquivo.filename, arquivo.body
end