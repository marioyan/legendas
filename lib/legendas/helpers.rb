require "lib/legendas/api"

module Legendas
  module Helpers
    def autenticar_como(usuario, senha)
      @api = Api.new
      @api.autenticar(usuario, senha)
    end

    def buscar(termo)
      yield @api.buscar(termo)
    end

    def baixar(id)
      arquivo = @api.baixar(id)
  
      yield arquivo[:nome], arquivo[:conteudo]
    end
  end
end