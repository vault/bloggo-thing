
require 'rubygems'
require 'couchrest'
require 'openssl'
require 'haml'
require 'bluecloth'

# List of posts
get '/' do
  params[:page] ||= 1
  skip = params[:page] * PER_PAGE
  @posts = DB.view("posts", :skip => skip, :limit => PER_PAGE)
end

# Individual post
get '/:title' do
  @article = DB.get(params[:name])
  @author = DB.get @article[:author]
  haml :page
end

# create a new post
post '/' do
  verify_authenticity!
  data = JSON.parse params[:data]
  halt 400 unless data[:title] && data[:body]
  id = sanitize_title data[:title]
  DB.save({"_id" => id,
           "author" => @user["_id"],
           "title" => data[:title],
           "body" => data[:body]})
end

