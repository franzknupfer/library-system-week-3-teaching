require('sinatra')
require('sinatra/reloader')
also_reload('lib/**/*.rb')
require('./lib/author.rb')
require('./lib/book.rb')
require('./lib/patron.rb')
require('pg')
require('pry')

DB = PG.connect({:dbname => 'library_database'})

get('/') do
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

get('/books') do
  @books = Book.all
  @authors = Author.all
  erb(:books)
end

get('/books/:id') do
  @book = Book.find(params.fetch("id").to_i)
  erb(:book)
end

get('/authors/:id') do
  @author = Author.find(params.fetch("id").to_i)
  erb(:author)
end

post('/books') do
  @title = params.fetch("title")
  new_book = Book.new({ :title => @title, :id => nil })
  new_book.save
  @name = params.fetch("name")
  new_author = Author.new({ :name => @name, :id => nil })
  new_author.save
  new_book.update({:author_ids => [new_author.id]})
  #Note: it isn't necessary to update both the book and the author; this is a many-to-many relationship and the association is made. Updating both will create a duplicate
  @books = Book.all
  @authors = Author.all
  erb(:books)
end

get('/authors') do
  @authors = Author.all
  erb(:authors)
end
