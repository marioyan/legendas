require "test/unit"
require "mocha"

require "legendas/api"
require "legendas/helpers"

class HelpersTest < Test::Unit::TestCase
  def setup
    @object = Object.new
    @object.extend(Legendas::Helpers)
  end
  
  def test_deve_executar_o_metodo_autenticar_da_api_quando_autenticar_como_for_chamado
    api = mock()
    api.expects(:autenticar).with(:p1, :p2).returns(:result)
    
    Legendas::Api.expects(:new).returns(api)
    
    assert_equal :result, @object.autenticar_como(:p1, :p2)
  end
  
  def test_deve_executar_o_metodo_buscar_da_api_quando_buscar_for_chamado
    api = mock()
    api.stubs(:autenticar)
    api.expects(:buscar).with(:p1).returns(:result)
    
    Legendas::Api.expects(:new).returns(api)
    
    @object.autenticar_como :p1, :p2
    
    @object.buscar :p1 do |resultado|
      assert_equal :result, resultado
    end
  end
  
  def test_deve_executar_o_metodo_baixar_da_api_quando_baixar_for_chamado
    api = mock()
    api.stubs(:autenticar)
    api.expects(:baixar).with(:p1).returns({ :nome => :r1, :conteudo => :r2 })
    
    Legendas::Api.expects(:new).returns(api)
    
    @object.autenticar_como :p1, :p2
    
    @object.baixar :p1 do |nome, conteudo|
      assert_equal :r1, nome
      assert_equal :r2, conteudo
    end
  end
end