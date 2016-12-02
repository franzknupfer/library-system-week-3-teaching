class Author
  attr_reader :name, :book_id, :id

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @book_id = attributes.fetch(:book_id)
  end

  define_method(:==) do |other_author|
    (self.name == (other_author.name))&&(self.book_id == (other_author.book_id))
  end

  define_singleton_method(:all) do
    all_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    all_authors.each do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      book_id = author.fetch("book_id").to_i
      authors.push(Author.new(:name => name, :id => id, :book_id => book_id))
    end
    authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name, book_id) VALUES ('#{ self.name }', #{ self.book_id }) RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  define_singleton_method(:find) do |id|
    found_author = nil
    Author.all.each do |author|
      if author.id == id
        found_author = author
      end
    end
    found_author
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    @book_id = attributes.fetch(:book_id, @book_id)
    @book_ids = attributes.fetch(:book_ids, [])
    @id = self.id
    DB.exec("UPDATE authors SET name = '#{@name}', book_id = #{@book_id}, book_ids = #{@book_ids} WHERE id = #{@id};")
  end

  define_method(:delete) do
    DB.exec("DELETE from authors WHERE id = #{self.id};")
  end

  define_method(:books) do
    books = DB.exec("SELECT * FROM books WHERE author_id = #{ self.id };")
    author_books = []
    books.each do |book|
      title = book.fetch("title")
      id = book.fetch("id").to_i
      author_id = book.fetch("author_id").to_i
      author_books.push(Book.new(:title => title, :id => id, :author_id => author_id))
    end
    author_books
  end

end
