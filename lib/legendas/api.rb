require "rubygems"
require "mechanize"

module Legendas
  class Api
    def initialize
      @agente = Mechanize.new
    end
  
    def autenticar(usuario, senha)
      @pagina_inicial = @agente.get("http://legendas.tv")
    
      form_login = @pagina_inicial.form_with(:action => "login_verificar.php")
      form_login["txtLogin"] = usuario
      form_login["txtSenha"] = senha

      retorno = @agente.submit(form_login)
      retorno.search("//*[contains(text(), 'Dados incorretos!')]").empty?
    end
  
    def buscar(termo)
      form_busca = @pagina_inicial.form_with(:action => "index.php?opcao=buscarlegenda")
      form_busca["txtLegenda"] = termo

      pagina_busca = @agente.submit(form_busca)
    
      legendas = []

      pagina_busca.search("#conteudodest > div > span").each do |item|
        elemento_id = item.search(".buscaDestaque", ".buscaNDestaque")
        elemento_nome = item.search(".brls")
  
        id = elemento_id.attr("onclick").text
        id = id.gsub(/(javascript|abredown|[^a-zA-Z0-9])/,"")
    
        nome = elemento_nome.text
  
        legendas << { :id => id, :nome => nome }
      end
    
      legendas
    end
  
    def baixar(id)
      arquivo = @agente.get("http://legendas.tv/info.php?d=#{id}&c=1")
  
      { :nome => arquivo.filename, :conteudo => arquivo.body }
    end
  end
end