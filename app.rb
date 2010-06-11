
require 'rubygems'
require 'sinatra'
require 'json'
require 'openssl'
require 'haml'
require 'rdiscount'

PER_PAGE = 15
POSTS = {}
USERS = {}

require 'helpers'

configure do
  read_all_users!
  read_all_posts!
end

# List posts
get '/' do
  params['page'] ||= 1
  skip = (params['page']-1) * PER_PAGE
  @posts = POSTS.values.sort{|x,y|x['date_posted']<=>y['date_posted']}[skip,skip+PER_PAGE]
  @users = USERS
  @title = "Index"
  haml :index
end

# Individual post
get '/:title' do
  @article = get_article params['title']
  @author = get_user @article['author']
  @title = @article['title']
  haml :page
end

# create a new post
post '/' do
  halt 400 unless params['hash'] && params['data'] && params['email']
  email = params['email']
  @user = get_user email
  data = JSON.parse decrypt_data!
  status = post_doc data
  if status == 'new'
    return "\"#{data['title']}\" posted"
  else
    return "\"#{data['title']}\" updated"
  end
end

