
require 'rubygems'
require 'sinatra'
require 'json'
require 'couchrest'
require 'openssl'
require 'haml'
require 'rdiscount'
require 'lib/smartmd.rb'

require 'helpers'

configure do
  set :db, CouchRest.database!("localhost:5984/blog")
  set :per_page, 2
end

# List posts
get '/' do
  @page = params['page'] ? params['page'].to_i : 1
  skip = @page.pred * settings.per_page
  @posts = posts_array settings.db.view('posts/by_date',
                                        :skip => skip,
                                        :limit => settings.per_page,
                                        :descending => true)['rows']
  @users = usershash
  $stderr.puts @users
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

