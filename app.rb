require "rubygems"
require "sinatra"
require "haml"
require "mechanize"

require "lib/legendas"

get "/" do
  haml :index
end

get "/buscar" do
  @legendas = []
  
  autenticado_como "legendas1517", "legendas1517" do
    buscar params[:termo] do |id, nome|
      @legendas << { :id => id, :nome => nome }
    end
  end
  
  haml :buscar
end

get "/baixar/:id" do |id|
  autenticado_como "legendas1517", "legendas1517" do
    baixar id do |nome, conteudo|
      response["Content-Type"] = mime_type(File.extname(nome))
      response["Content-Length"] = conteudo.length
      response["Content-Disposition"] = "inline"
      
      halt conteudo
    end
  end
end