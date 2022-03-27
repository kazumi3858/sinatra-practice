# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def create_memo(memo)
  File.open("./memos/#{memo[:id]}.json", 'w') do |file|
    file.puts(memo.to_json)
  end
end

def read_memo
  memo = {}
  memo[:id] = params[:id].to_i
  data = JSON.parse(File.read("./memos/#{memo[:id]}.json"), symbolize_names: true)
  memo[:title] = h(data[:title])
  memo[:content] = h(data[:content])
  memo
end

get '/' do
  @memos = Dir.glob('./memos/*.json').sort_by { |file| File.birthtime(file) }
  erb :index
end

post '/' do
  memo = {}
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:id] = memo[:title].object_id
  create_memo(memo)
  redirect to("/memos/#{memo[:id]}")
  erb :index
end

get '/memos/:id' do
  @memo = read_memo
  erb :memo
end

get '/new' do
  erb :new
end

delete '/memos/:id' do
  id = params[:id].to_i
  File.delete("./memos/#{id}.json")
  redirect to('/')
  erb :memo
end

patch '/memos/:id' do
  memo = {}
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:id] = params[:id].to_i
  create_memo(memo)
  redirect to("/memos/#{memo[:id]}")
  erb :edit
end

get '/memos/:id/edit' do
  @memo = read_memo
  erb :edit
end
