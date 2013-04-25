enable :sessions

get '/' do
  @list_short_urls = Url.all
  erb :index
end


#####################dummybrowser routes##############
#change create to create_account
get '/create' do
  erb :create_account
end

post '/create' do
  @list_short_urls = Url.all
  User.create(params)
  @message = "Login with your new account details"
  erb :index
end

post '/login' do
  if User.login(params)
    @user = User.find_by_email(params[:email])
    @list_short_urls = @user.urls
    session[:id] = @user.id
    erb :secret_page
  else
    @message = "Error, either username or password incorrect"
    erb :index
  end
end

get '/logout' do
  @list_short_urls = Url.all
  session.clear
  erb :index
end

get '/secret' do
  if session[:id] 
    @list_short_urls = User.find(session[:id]).urls
    erb :secret_page
  else
    @message = "You must be logged in to see that page!"
    @list_short_urls = Url.all
    erb :index
  end
end

#########################Url shortener##################
post '/urls' do
  puts "Someone tried to shorten a url"
  @url = Url.new(params)
  if @url.valid?
    @url.create_short_url
    erb :display
  else
    @error = @url.errors.full_messages.first
    @list_short_urls = Url.all
    erb :index
  end
end

post '/secret_urls' do
  puts "Someone who is logged in tried to shorten a url"
  @user = User.find(session[:id])
  @url = Url.new(params)
  if @url.valid?
    @user.urls << @url.create_short_url
    # line above might cause an issue
    erb :display_secret
  else
    @error = @url.errors.full_messages.first
    @list_short_urls = @user.urls
    # we should actually go to erb :secret with the error message
    erb :secret_page
  end
end

get '/:short_url' do
  short_url = params[:short_url]
  url = Url.where('short_url = ?', short_url).first
  url.increment_click_count
  redirect url.long_url
end

get '/users/:id' do
  @user = User.find(params[:id])

  erb :profile
end



