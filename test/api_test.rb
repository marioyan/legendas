require "test/unit"

require "rubygems"
require "fakeweb"

require "legendas/api"

class ApiTest < Test::Unit::TestCase
  def setup
    FakeWeb.allow_net_connect = false
    FakeWeb.clean_registry
    
    register_get_uri "/", "pagina_inicial.html"
    
    @api = Legendas::Api.new
  end
  
  def test_deve_retornar_verdadeiro_quando_conseguir_autenticar_no_site
    register_post_uri "/login_verificar.php", "sucesso_no_login.html"
    
    assert @api.autenticar("john", "doe")
  end
  
  def test_deve_retornar_falso_quando_nao_conseguir_autenticar_no_site
    register_post_uri "/login_verificar.php", "falha_no_login.html"
    
    assert_equal false, @api.autenticar("john", "doe")
  end
  
  def test_deve_retornar_um_array_com_as_legendas_quando_buscar_por_um_termo_valido
    register_post_uri "/login_verificar.php", "sucesso_no_login.html"
    register_post_uri "/index.php?opcao=buscarlegenda", "sucesso_na_busca.html"
    
    @api.autenticar("john", "doe")
    
    esperado = [ { :id => "4d109fc88be299bd5d71f4822bc7107c", :nome => "Chuck.S04E01.HDTV.XviD-LOL/ DIMENSION" } ]
    retorno = @api.buscar("Chuck S04 E01")
    
    assert_equal esperado, retorno
  end
  
  def test_deve_retornar_um_hash_com_o_nome_e_o_conteudo_do_arquivo_quando_baixar_uma_legenda
    register_post_uri "/login_verificar.php", "sucesso_no_login.html"
    register_file_uri "/info.php?d=4d109fc88be299bd5d71f4822bc7107c&c=1", "legendas.zip"
    
    @api.autenticar("john", "doe")
    
    retorno = @api.baixar("4d109fc88be299bd5d71f4822bc7107c")
    
    assert_equal "legendas.zip", retorno[:nome]
    assert_equal File.read(File.dirname(__FILE__) + "/legendas.zip"), retorno[:conteudo]
  end
  
  private
    
    def register_get_uri(page, file)
      FakeWeb.register_uri :get, "http://legendas.tv#{page}",
                           :body => File.dirname(__FILE__) + "/#{file}",
                           :content_type => "text/html"
    end
    
    def register_post_uri(page, file)
      FakeWeb.register_uri :post, "http://legendas.tv#{page}",
                           :body => File.dirname(__FILE__) + "/#{file}",
                           :content_type => "text/html"
    end

    def register_file_uri(page, file)
     FakeWeb.register_uri :get, "http://legendas.tv#{page}",
                          :body => File.dirname(__FILE__) + "/#{file}",
                          :content_disposition => "inline; filename=#{file}"
    end
end