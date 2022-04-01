# Simple Memo
## Description
Simple Memo is a web application that creates memo list by adding a title and its content.
This uses postgreSQL to save data.

## How to use
1. Make a directory and move into it on your terminal.
2. Clone this repository.

```
$ git clone https://github.com/kazumi3858/sinatra-practice.git
```

3. Install gems.

```
$ bundle install
```

4. Open app.rb and modify default database information to yours.

```ruby
def initialize
  @db_connection = PG.connect(host: 'localhost', user: 'username', password: 'password', dbname: 'dbname')
end
```

5. Start postgreSQL.

```
$ sudo service postgresql start
```

6. Execute app.rb.

```
$ bundle exec ruby app.rb
```

7. Access `http://localhost:4567/` on your web browser.
8. Click `Create Memo` button to post.
