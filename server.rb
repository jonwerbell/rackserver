require 'rubygems'
require 'rack'
require 'awesome_print'

# build content length header (size of the file in bites)
# Content-Length: 42

# and if the file is not file, return a 404 error

#gemfile
#server
#  public directory
#    index.html
    
# possible to do images - just a different content type

class HelloWorld

  def get_content(file_name)
    file = File.open("public#{file_name}", 'r')
    file.read()
  end

  def call(env)   
    file_name = env["REQUEST_PATH"]
    if file_name == "/"
      file_name = "/index.html"
    end
    
    file_path = "public" + file_name
    
    if FileTest.exists?(file_path)
      [200, {"Content-Type" => "text/html"}, [get_content(file_name)]]
    else
      [404, {}, ["You have an error"]]
    end
  end
end

Rack::Handler::Mongrel.run HelloWorld.new, :Port => 9292