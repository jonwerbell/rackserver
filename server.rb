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
  
  def get_size(file_name)
    File.size("public#{file_name}")
  end

  def call(env)   
    
    ap env
    
    file_name = env["REQUEST_PATH"]
    if file_name == "/"
      file_name = "/index.html"
    elsif file_name == "/subfolder/"
      file_name = "/subfolder/index.html"
    end
    
    file_path = "public" + file_name
    
    if FileTest.exists?(file_path)
      if file_path.match(/.*\.jpg/)
        [200, {"Content-Type" => "image/jpeg", "Content-Length" => "#{get_size(file_name)}"}, [get_content(file_name)]]
      elsif file_path.match(/.*\.html/)
        [200, {"Content-Type" => "text/html", "Content-Length" => "#{get_size(file_name)}"}, [get_content(file_name)]]
      elsif file_path.match(/.*\.mp4/)
         [200, {"Content-Type" => "video/mp4", "Content-Length" => "#{get_size(file_name)}"}, [get_content(file_name)]]
      end
    else
      [404, {}, ["404 Not Found"]]
    end
  end
end

Rack::Handler::Mongrel.run HelloWorld.new, :Port => 9292