class Api
  def initialize(login, password, cookies)
    @login, @password, @cookies = login, password, cookies
    
    @agent = Mechanize.new
    
    if File.exist?(@cookies)
      @agent.cookie_jar.load @cookies, :cookiestxt
    end
  end
  
  def search(query)
    search_for query
    
    unless authenticated?
      authenticate
      search_for query
    end
    
    subtitles = []
    
    @agent.page.search("#conteudodest > div > span").each do |item|
      subtitles << create_subtitle_from(item)
    end
    
    subtitles
  end
  
  def get(id)
    @agent.get "http://legendas.tv/info.php?d=#{id}&c=1"
  end
  
  private
    
    def search_for(query)
      @agent.post "http://legendas.tv/index.php?opcao=buscarlegenda", { txtLegenda: query, selTipo: 1, int_idioma: 1 }
    end
    
    def authenticated?
      !@agent.page.link_with(href: "logoff.php").nil?
    end
    
    def authenticate
      @agent.post "http://legendas.tv/login_verificar.php", { txtLogin: @login, txtSenha: @password, chkLogin: 1 }
      @agent.cookie_jar.save_as @cookies, format: :cookiestxt, session: true
    end
    
    def create_subtitle_from(item)
      id = get_id(item)
      release = get_release(item)
      uploader = get_uploader(item)
      
      Subtitle.new id, release, uploader
    end
    
    def get_id(item)
      element = item.search(".buscaDestaque", ".buscaNDestaque")
      element.attr("onclick").text.gsub(/(javascript|abredown|[^a-zA-Z0-9])/,"")
    end
    
    def get_release(item)
      element = item.search(".brls")
      element.text
    end
    
    def get_uploader(item)
      element = item.search("a")
      element.text
    end
end
