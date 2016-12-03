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

post('/') do
  title = params.fetch("title")
  new_book = Book.new({ :title => title, :id => nil })
  new_book.save
  name = params.fetch("name")
  new_author = Author.new({ :name => name, :id => nil })
  new_author.save
  new_book.update({:author_ids => [new_author.id]})
  #Note: it isn't necessary to update both the book and the author; this is a many-to-many relationship and the association is made. Updating both will create a duplicate
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

post("/clear") do
  Author.clear
  Book.clear
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

get('/books/:id') do
  @book = Book.find(params.fetch("id").to_i)
  erb(:book)
end

get('/authors/:id') do
  @author = Author.find(params.fetch("id").to_i)
  erb(:author)
end

get('/authors/:id/duplicates') do
  @author = Author.find(params.fetch("id").to_i)
  @duplicates = @author.duplicates
  erb(:duplicate_authors)
end

post('/authors/:id/duplicates') do
  @author = Author.find(params.fetch("id").to_i)
  merge_id = params.fetch("merge_id")
  author2 = Author.find(params.fetch("merge_id").to_i)
  @author.merge(author2)
  @duplicates = @author.duplicates
  erb(:duplicate_authors)
end

post('/authors/:id') do
  @author = Author.find(params.fetch("id").to_i)
  title = params.fetch("title")
  book = Book.new({:title => title, :id => nil})
  book.save
  binding.pry
  @author.update({:book_ids => [book.id]})
  erb(:author)
end

delete('/authors/:id') do
  @author = Author.find(params.fetch("id").to_i)
  @author.delete
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

delete('/books/:id') do
  @book = Book.find(params.fetch("id").to_i)
  @book.delete
  @books = Book.all
  @authors = Author.all
  erb(:index)
end
