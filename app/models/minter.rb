require 'net/http'
require 'uri'
require 'yaml'

class Minter
  def initialize
    @scope ||= "default"
    @config = YAML.load(IO.read(File.expand_path('../../../config/minter.yml', __FILE__)))[@scope]
  end

  def mint
    run
  end

  private

  def run
    uri = URI.parse(@config['host'])
    response = Net::HTTP.post_form(uri, query)

    if response.code == "200"
      parse_identifier response.body
    end
  end

  def query
    {shoulder: @config['shoulder']}
  end

  def parse_identifier(body)
    identifier = /id:\s+(\S+)/.match(body)[1]
    if @config['elide_string']
      identifier.sub!(@config['elide_string'], '')
    end
    identifier
  end
end

if __FILE__ == $0
  m = Minter.new
  puts m.mint
end
