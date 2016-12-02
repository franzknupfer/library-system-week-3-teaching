require 'pry'

class Book
  attr_reader :title, :id

  define_method(:initialize) do |attributes|
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  define_singleton_method(:all) do
    all_books = DB.exec("SELECT * FROM books;")
    books = []
    all_books.each do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i
      books.push(Book.new({:title => title, :id => id}))
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
    (self.title == (other_book.title))
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{@title}' WHERE id = #{self.id};")

    attributes.fetch(:author_ids, []).each do |author_id|
      DB.exec("INSERT INTO books_authors (book_id, author_id) VALUES ( #{self.id}, #{author_id} );")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE from books_authors WHERE book_id = #{self.id};")
    DB.exec("DELETE from books WHERE id = #{self.id};")
  end

  define_method(:authors) do
    book_authors = []
    results = DB.exec("SELECT author_id FROM books_authors WHERE book_id = #{self.id};")
    results.each do |result|
      author_id = result.fetch("author_id").to_i
      author = DB.exec("SELECT * FROM authors WHERE id = #{ author_id };")
      name = author.first.fetch("name")
      id = author.first.fetch("id").to_i
      book_authors.push(Author.new(:name => name, :id => id))
    end
    book_authors
  end


end
