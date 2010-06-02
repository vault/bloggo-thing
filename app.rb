
require 'sinatra'
require 'rubygems'
require 'couchrest'
require 'openssl'
require 'haml'
require 'bluecloth'

require 'helpers'

$DB = CouchRest.database!("http://127.0.0.1:5984/blog")
PER_PAGE = 15

# List posts
get '/' do
  params[:page] ||= 1
  skip = params[:page] * PER_PAGE
  @posts = $DB.view("posts/by_date", :skip => skip, :limit => PER_PAGE)
  @users = $DB.view("users/all")
  haml :index
  "Hello World!"
end

# Individual post
get '/:title' do
  @article = $DB.get(params[:name])
  @author = $DB.get @article[:author]
  haml :page
end

# create a new post
post '/' do
  halt 400 unless params[:hash] && params[:data] && params[:email]
  email = params[:email]
  @user = $DB.get email
  data = JSON.parse decrypt_data!
  status post_doc data
  if status == 'new'
    "\"#{data["title"]}\" posted"
  else
    "\"#{data["title"]}\" updated"
  end
end

