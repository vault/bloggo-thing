
require 'rubygems'
require 'sinatra'
require 'json'
require 'couchrest'
require 'openssl'
require 'haml'
require 'rdiscount'
require 'lib/smartmd.rb'

PER_PAGE = 2
POSTS = {}
SORTED_POSTS = []
USERS = {}

require 'helpers'

configure do
  read_all_users!
  read_all_posts!
  sort_posts!
end

# List posts
get '/' do
  @page = params['page'] ? params['page'].to_i : 1
  skip = @page.pred * PER_PAGE
  @posts = SORTED_POSTS[skip...skip+PER_PAGE]
  @users = USERS
  @title = "Index"
  haml :index
end

# Individual post
get '/:title' do
  @post = get_article params['title']
  @author = get_user @post['author']
  @title = @post['title']
  haml :page
end

# create a new post
put '/' do
  halt 400 unless params['hash'] && params['data'] && params['email']
  email = params['email']
  @user = get_user email
  data = JSON.parse decrypt_data!
  stat = save_post data
  if stat == :new
    return "\"#{data['title']}\" posted"
  else
    return "\"#{data['title']}\" updated"
  end
end

