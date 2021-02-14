require "sinatra"
require "sinatra/reloader"
require "json"
require "securerandom"

class Memo
  def create(title:, content:)
    hash = { id: SecureRandom.uuid, title: title, content: content }
    File.open("model/#{hash[:id]}.json", "w") { |file| file.puts JSON.pretty_generate(hash) }
  end
  def find_by_id(id:)
    JSON.parse(File.read("model/#{id}.json"), symbolize_names: true)
  end
  def edit(id:, title:, content:)
    hash = { id: id, title: title, content: content }
    File.open("model/#{hash[:id]}.json", "w") { |file| file.puts JSON.pretty_generate(hash) }
  end
  def delete(id:)
    File.delete("model/#{id}.json")
  end
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get "/memos" do
  @title = "メモの一覧"
  files = Dir.glob("model/*").sort_by { |file| File.mtime(file) }
  @memos = files.map { |file| JSON.parse(File.read(file), symbolize_names: true) }
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
