require "heroku/command/base"

# Simple monitoring for your heroku app's database
class Heroku::Command::Monitor < Heroku::Command::Base

  # monitor
  #
  # register app with monitoring server
  #
  # -f, --frequency NUM      # number of minutes between snapshots
  #
  def index
    app = extract_app
    display "Starting monitoring for #{app}.#{heroku.host}"
    get_credentials
    begin
      @response = resource["/register"].post(:app => app, :apikey => @credentials[1], :frequency => options[:frequency])
    rescue RestClient::InternalServerError
      display "An error has occurred."
    end
  end

  # monitor:query
  #
  # query the app monitoring results
  #
  # -d, --days NUM      # number of recent days to show
  # -u, --url STR       # number of recent days to show
  # -m, --mode STR      # number of recent days to show
  #
  def query
    app = extract_app
    begin
      response = resource["/query/#{app}"].post(:days => options[:days], :url => options[:url], :mode => options[:mode])
    rescue RestClient::InternalServerError
      display "An error has occurred."
    end
    display response.to_s
  end

  # monitor:snapshot
  #
  # get a log snapshot
  #
  def snapshot
    app = extract_app
    begin
      response = resource["/snapshot/#{app}"].post(nil)
    rescue RestClient::InternalServerError
      display "An error has occurred."
    end
    display response.to_s
  end

  # monitor:analyse
  #
  # perform a log analysis, store and display the result
  #
  def analyse
    app = extract_app
    begin
      response = resource["/analyse/#{app}"].post(nil)
    rescue RestClient::InternalServerError
      display "An error has occurred."
    end
    display response.to_s
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

  def register(app, frequency)
  end

end
