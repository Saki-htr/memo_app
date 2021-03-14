# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "pg"

class Memo
  def initialize
    @connection = PG.connect(dbname: "memos")
  end

  def create(title:, content:)
    @connection.prepare("create", "INSERT INTO memos(title, content) VALUES ($1, $2)")
    @connection.exec_prepared("create", [title, content])
  end

  def show_memos
    @connection.prepare("show", "SELECT * FROM memos")
    @connection.exec_prepared("show")
  end

  def find_by_id(id:)
    @connection.prepare("find", "SELECT * FROM memos WHERE id = $1")
    @connection.exec_prepared("find", [id])
  end

  def edit(id:, title:, content:)
    @connection.prepare("edit", "UPDATE memos SET title = $1, content = $2 WHERE id = $3")
    @connection.exec_prepared("edit", [title, content, id])
  end

  def delete(id:)
    @connection.prepare("delete", "DELETE FROM memos WHERE id = $1")
    @connection.exec_prepared("delete", [id])
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get "/memos" do
  @title = "メモの一覧"
  @memos = Memo.new.show_memos
  erb :list
end

get "/memos/new" do
  @title = "メモの新規作成"
  erb :new
end

post "/memos/new" do
  @memo = Memo.new.create(title: params[:memo_title], content: params[:memo_content])
  redirect to("/memos")
end

get "/memos/:id" do
  @title = "メモの閲覧"
  @memo = Memo.new.find_by_id(id: params[:id])
  erb :show
end

get "/memos/:id/edit" do
  @title = "メモの編集"
  @memo = Memo.new.find_by_id(id: params[:id])
  erb :edit
end

patch "/memos/:id" do
  @memo = Memo.new.edit(id: params[:id], title: params[:memo_title], content: params[:memo_content])
  redirect to("/memos/#{params[:id]}")
end

delete "/memos/:id" do
  @memo = Memo.new.delete(id: params[:id])
  redirect to("/memos")
end
