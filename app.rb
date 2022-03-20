# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def create_file
  data = { 'id' => @id, 'title' => @title, 'content' => @content }
  File.open("./memos/#{@id}.json", 'w') do |file|
    file.puts(data.to_json)
  end
end

def data_from_file
  @id = params[:id].to_i
  data = JSON.parse(File.read("./memos/#{@id}.json"), symbolize_names: true)
  @title = data[:title]
  @content = data[:content]
end

get '/' do
  erb :index
end

post '/' do
  @title = h(params[:title])
  @content = h(params[:content])
  @id = @title.object_id
  create_file
  redirect to("/memos/#{@id}")
  erb :index
end

get '/memos/:id' do
  data_from_file
  erb :memos
end

get '/new' do
  erb :new
end

delete '/memos/:id' do
  @id = params[:id].to_i
  File.delete("./memos/#{@id}.json")
  redirect to('/')
  erb :memos
end

patch '/memos/:id' do
  @title = h(params[:title])
  @content = h(params[:content])
  @id = params[:id].to_i
  create_file
  redirect to("/memos/#{@id}")
  erb :edit
end

get '/memos/:id/edit' do
  data_from_file
  erb :edit
end
