# memo_app
## このリポジトリについて
フィヨルドブートキャンプのプラクティス「Sinatraを使ってWebアプリケーションの基本を理解する」の課題です。

## 概要

メモの作成・編集・削除ができるシンプルなWebアプリケーションです。


## 使い方
### データベースの作成

1. データベースに接続します。

```ruby
$ psql -U <dbname>
```

2. メモのデータを保存するデータベースを作成します。

```sql
postgres=# createdb memos;
```

3. 接続先のデータベースを`memos`に変更します。

```sql
postgres=# \c memos;
```

4. テーブルを作成します。

```aql
memos=# create table memos (
           id serial not null,
           title text,
           content text,
           primary key (id)
         );
```

### アプリの準備
1. sinatraのgemをinstallする
2. 
```ruby
gem install sinatra
```

2. リモートリポジトリをクローンする
```ruby
git clone  https://github.com/Saki-htr/memo_app.git
```
3. ターミナルで`memo_app` に移動して、 `ruby app.rb`を実行する
4. ブラウザで`http://localhost:4567/memos`にアクセスする
