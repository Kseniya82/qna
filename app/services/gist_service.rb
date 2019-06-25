class GistService
  def initialize(link, client = default_client)
    @gist_id = link.url.split('/').last
    @client = client
    @gist = @client.gist(@gist_id)
  end

  def content
    @gist.files.to_hash.each_with_object([]) do |file, result|
      result << { file_name: file[1][:filename], file_content: file[1][:content] }
    end
  end

  private

  def default_client
    Octokit::Client.new
  end
end
