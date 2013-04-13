set :root,  File.dirname(__FILE__)

before do
  @api = Api.new "legendas1517", "legendas1517", "tmp/cookies.txt"
end

get "/" do
  erb :index
end

get "/search" do
  @subtitles = @api.search params[:q]
  
  erb :search
end

get "/download" do
  subtitle_file = @api.get params[:id]
  
  send_data subtitle_file.body, :filename => subtitle_file.filename
end
