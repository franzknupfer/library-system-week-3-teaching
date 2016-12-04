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
  @user = params[:user]
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

post('/') do
  title = params[:title]
  new_book = Book.new({ :title => title, :id => nil, :due_date => nil, :patron_id => nil })
  new_book.save
  name = params[:name]
  new_author = Author.new({ :name => name, :id => nil })
  new_author.save
  new_book.update({:author_ids => [new_author.id]})
  #Note: it isn't necessary to update both the book and the author; this is a many-to-many relationship and the association is made. Updating both will create a duplicate
  @books = Book.all
  @authors = Author.all
  erb(:index)
end

get('/librarian') do
  erb(:librarian)
end

get('/login') do
  erb(:login)
end

get('/patron_dashboard') do
  @patron = Patron.find(params[:patron_id].to_i)
  if @patron
    erb(:patron_dashboard)
  else
    @notification = "You haven't signed up for an account yet."
    erb(:login)
  end
end

get('/patrons') do
  @patrons = Patron.all
  erb(:patrons)
end

post('/patron_dashboard') do
  name = params[:name]
  @patron = Patron.new(:name => name, :id => nil)
  @patron.save
  @notification = "Thanks for signing up! Don't lose your Patron ID. You'll need it to sign in."
  erb(:patron_dashboard)
end

post("/checkout") do
  @book = Book.find(params[:book_id].to_i)
  @patron = Patron.find(params[:patron_id].to_i)
  @patron.checkout(@book)
  erb(:patron_dashboard)
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
  @author = Author.find(params[:id].to_i)
  title = params[:title]
  book = Book.new({ :title => title, :id => nil, :due_date => nil, :patron_id => nil })
  book.save
  @author.update({:book_ids => [ book.id ]})
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
