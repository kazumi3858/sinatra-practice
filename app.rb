# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def save_memo(memo)
  File.open("./memos/#{memo[:id]}.json", 'w') do |file|
    file.puts(memo.to_json)
  end
end

def read_memo(id)
  JSON.parse(File.read("./memos/#{id}.json"), symbolize_names: true)
end

def delete_memo(id)
  File.delete("./memos/#{id}.json")
end

get '/' do
  files = Dir.glob('./memos/*.json').sort_by { |file| File.birthtime(file) }
  @memos = files.reverse.map do |file|
    id = File.basename(file, '.json')
    read_memo(id)
  end
  erb :index
end

post '/' do
  memo = {}
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:id] = SecureRandom.uuid
  save_memo(memo)
  redirect to("/memos/#{memo[:id]}")
end

get '/memos/:id' do
  @memo = read_memo(params[:id])
  erb :memo
end

get '/new' do
  erb :new
end

delete '/memos/:id' do
  delete_memo(params[:id])
  redirect to('/')
end

patch '/memos/:id' do
  memo = {}
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:id] = params[:id]
  save_memo(memo)
  redirect to("/memos/#{memo[:id]}")
end

get '/memos/:id/edit' do
  @memo = read_memo(params[:id])
  erb :edit
end
