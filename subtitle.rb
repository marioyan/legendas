class Subtitle
  attr_reader :id, :release, :uploader
  
  def initialize(id, release, uploader)
    @id, @release, @uploader = id, release, uploader
  end
end
