require 'pry'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'


before do
  q = "SELECT DISTINCT genre FROM videos"
  @genres = run_sql(q)

end

get '/' do

  erb :home
end

get '/new' do
  erb :new
end

post '/create' do
  q = "INSERT INTO videos (title, description, url, genre, code ) VALUES
  ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{params['genre']}', '#{params['code']}')"
  run_sql(q)
  redirect to('/videos')

  #binding.pry
end

post '/videos/:id' do
  #binding.pry
  q = "UPDATE videos SET title='#{params['title']}', description='#{params['description']}',
        url='#{params['url']}', genre='#{params['genre']}', code='#{params['code']}' WHERE id='#{params[:id]}'"
  run_sql(q)
  redirect to('/videos')

end

get '/videos/:id/edit' do
  q = "SELECT * FROM videos WHERE id=#{params[:id]}"
  rows = run_sql(q)
  @video = rows.first

  erb :new
end


post '/videos/:id/delete' do
  q = "DELETE FROM videos WHERE id=#{params[:id]}"
  run_sql(q)
  redirect to ('/videos')
end


get '/videos' do
  q = "SELECT * FROM videos"
  @videos = run_sql(q)

  erb :videos
end

get '/videos/:genre' do
 q = "SELECT * FROM videos WHERE genre='#{params[:genre]}'"
 @videos = run_sql(q)

 erb :videos
end

def run_sql(query)
  conn = PG.connect(:dbname => 'meme', :host => 'localhost')
  result = conn.exec(query)
  conn.close

  result
end


