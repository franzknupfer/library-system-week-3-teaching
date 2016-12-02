require 'pry'

class Book
  attr_reader :title, :id, :author_id

  define_method(:initialize) do |attributes|
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
    @author_id = attributes.fetch(:author_id)
  end

  define_singleton_method(:all) do
    all_books = DB.exec("SELECT * FROM books;")
    books = []
    all_books.each do |book|
      title = book.fetch("title")
      author_id = book.fetch("author_id").to_i
      id = book.fetch("id").to_i
      books.push(Book.new({:title => title, :author_id => author_id, :id => id}))
    end
    books
  end

  define_singleton_method(:find) do |id|
     found_book = nil
     Book.all().each() do |book|
       if (book.id) ===(id)
         found_book = book
       end
     end
     found_book

   end

  define_method(:==) do |other_book|
    (self.title == (other_book.title))&&(self.author_id == (other_book.author_id))
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title, author_id) VALUES ('#{@title}', #{@author_id}) RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    @author_id = attributes.fetch(:author_id, @author_id)
    @id = self.id
    DB.exec("UPDATE books SET title = '#{@title}', author_id = #{@author_id} WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE from books WHERE id = #{self.id};")
  end

  define_method(:authors) do
    all_authors = []
    authors = DB.exec("SELECT * FROM authors WHERE book_id = #{self.id};")
    authors.each do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      book_id = author.fetch("book_id").to_i
      all_authors.push(Author.new(:name => name, :id => id, :book_id => book_id))
    end
    all_authors
  end


end
