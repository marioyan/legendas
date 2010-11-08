require "rubygems"
require "sinatra"
require "haml"

require "lib/legendas"

get "/" do
  haml :index
end

get "/buscar" do
  autenticar_como "legendas1517", "legendas1517"
  
  buscar params[:termo] do |legendas|
    @legendas = legendas
  end
  
  haml :buscar
end

get "/baixar/:id" do |id|
  autenticar_como "legendas1517", "legendas1517"
  
  baixar id do |nome, conteudo|
    response["Content-Type"] = mime_type(File.extname(nome))
    response["Content-Length"] = conteudo.length
    response["Content-Disposition"] = "inline; filename=#{nome}"
    
    halt conteudo
  end
end