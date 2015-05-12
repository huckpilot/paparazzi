require 'sinatra'
require 'sqlite3'
require 'httparty'
require 'json'
require 'pry'

# apiKey = 91fd1114cf5846158c437494c6292f40;

db = SQLite3::Database.new 'paparazzi.db'
rows = db.execute <<-SQL
create table if not exists pictures(
  id INTEGER PRIMARY KEY, 
  picture TEXT
  );
SQL

# def instagram_photos(tag) 
#  the_data = HTTParty.get("https://api.instagram.com/v1/tags/#{tag}/media/recent?client_id=91fd1114cf5846158c437494c6292f40")
 
#  return the_data["data"]
# end

get '/' do 
  pictures = db.execute("SELECT picture FROM pictures")
  # binding.pry
  erb :form, locals: {pictures: pictures}
end

get '/tags' do
  tag=params[:tag].gsub(/ /,"_")
  the_data = HTTParty.get("https://api.instagram.com/v1/tags/#{tag}/media/recent?client_id=91fd1114cf5846158c437494c6292f40")
  # binding.pry
  thumbnails = []
  i = 0
  while i < 11 && i < the_data["data"].length
    i+=1
    thumbnails.push(the_data["data"][i]["images"]["thumbnail"]["url"])
  end
  erb :show, locals: {pictures: thumbnails}
end


post '/' do
  # binding.pry
  params.each do |key, value|
  db.execute("INSERT INTO pictures (picture) VALUES (?)", value)
  end
  redirect "/"
end