# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'securerandom'
require 'pg'

# Please input your database information in the initialize method
class Memo
  attr_accessor :db_connection

  def initialize
    @db_connection = PG.connect(host: 'localhost', user: 'username', password: 'password', dbname: 'dbname')
  end

  def save_memo(title, content)
    db_connection.exec('INSERT INTO memos (title, content) VALUES ($1, $2) RETURNING id', [title, content])
  end

  def read_memo(id)
    db_connection.exec('SELECT * FROM memos WHERE id = $1', [id])
  end

  def read_memos
    db_connection.exec('SELECT * FROM memos ORDER BY id DESC')
  end

  def update_memo(title, content, id)
    db_connection.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, id])
  end

  def delete_memo(id)
    db_connection.exec('DELETE FROM memos WHERE id = $1', [id])
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  @memos = Memo.new.read_memos
  erb :index
end

post '/' do
  title = params[:title]
  content = params[:content]
  memo = Memo.new.save_memo(title, content)
  redirect to("/memos/#{memo[0]['id']}")
end

get '/memos/:id' do
  id = params[:id]
  @memo = Memo.new.read_memo(id)[0]
  erb :memo
end

get '/new' do
  erb :new
end

delete '/memos/:id' do
  id = params[:id]
  Memo.new.delete_memo(id)
  redirect to('/')
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  id = params[:id]
  Memo.new.update_memo(title, content, id)
  redirect to("/memos/#{id}")
end

get '/memos/:id/edit' do
  id = params[:id]
  @memo = Memo.new.read_memo(id)[0]
  erb :edit
end
