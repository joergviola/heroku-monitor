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


	def user    # :nodoc:
	  get_credentials
	  @credentials[0]
	end
	
	def password    # :nodoc:
	  get_credentials
	  @credentials[1]
	end
	
	def credentials_file
      "#{home_directory}/.heroku/credentials"
	end
	
	def get_credentials    # :nodoc:
	  return if @credentials
	  unless @credentials = read_credentials
	    ask_for_and_save_credentials
	  end
	  @credentials
	end
	
	def read_credentials
	  File.exists?(credentials_file) and File.read(credentials_file).split("\n")
	end

  private
  def resource
    @resource ||= RestClient::Resource.new("https://monitor.herokuapp.com")
  end

  def register(app)
    get_credentials
    resource["/register"].post(:app => app, :uid => @credentials[0], :pwd => @creadentials[1])
  rescue RestClient::InternalServerError
    display "An error has occurred."
  end

end
