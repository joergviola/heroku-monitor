require "heroku/command/base"

# Simple monitoring for your heroku app's database
class Heroku::Command::Monitor < Heroku::Command::Base

  # monitor
  #
  # register app with monitoring server
  #
  # -d, --days NUM      # number of recent days to show
  #
  def index
    app = extract_app
    display "Starting monitoring for #{app}.#{heroku.host}"
    register(app, options[:frequency]).to_s;
  end

  def query
    app = extract_app
    display options[:days] 
    doQuery(app, options[:days], options[:url], options[:mode]).to_s;
  end

	def credentials_file
      "#{home_directory}/.heroku/credentials"
	end
	
	def get_credentials    # :nodoc:
	  return if @credentials
	  @credentials = read_credentials
	  @credentials
	end
	
	def read_credentials
	  File.exists?(credentials_file) and File.read(credentials_file).split("\n")
	end

  private
  def resource
    @resource ||= RestClient::Resource.new("http://heromon.herokuapp.com")
  end

  def doQuery(app, days, url, mode)
    display "query #{app} #{days} #{url} #{mode}"
    begin
      response = resource["/query/#{app}"].post(:days => days, :url => url, :mode => mode)
    rescue RestClient::InternalServerError
      display "An error has occurred."
    end
    display "-> #{response.to_s}"
    response
  end

  def register(app, frequency)
    get_credentials
    @response = resource["/register"].post(:app => app, :apikey => @credentials[1], :frequency => frequency)
  rescue RestClient::InternalServerError
    display "An error has occurred."
  end

end
