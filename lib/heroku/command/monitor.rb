# Simple monitoring for your heroku app's database
class Heroku::Command::Monitor < Heroku::Command::Base

  # monitor
  #
  # register app with monitoring server
  #
  def index
    app = extract_app
    display "Starting monitoring for #{app}.#{heroku.host}"
    register(app);
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
    @resource ||= RestClient::Resource.new("http://monitor.herokuapp.com")
  end

  def register(app)
    get_credentials
    display "cf #{credentials_file}"
    display "user #{@credentials[0]}"
    resource["/register"].post(:app => app, :uid => @credentials[0], :pwd => @creadentials[1])
  rescue RestClient::InternalServerError
    display "An error has occurred."
  end

end
