class Author
  attr_reader :name, :id

  define_method(:initialize) do |attributes|
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  define_method(:==) do |other_author|
    (self.name == (other_author.name))
  end

  define_singleton_method(:all) do
    all_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    all_authors.each do |author|
      name = author.fetch("name")
      id = author.fetch("id").to_i
      authors.push(Author.new(:name => name, :id => id))
    end
    authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{ self.name }') RETURNING id;")
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
    DB.exec("UPDATE authors SET name = '#{@name}' WHERE id = #{self.id};")

    attributes.fetch(:book_ids, []).each do |book_id|
      DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{self.id}, #{book_id});")
    end
  end

  define_method(:delete) do
    DB.exec("DELETE from books_authors WHERE author_id = #{self.id};")
    DB.exec("DELETE from authors WHERE id = #{self.id};")
  end

  define_method(:books) do
    book_authors = []
    results = DB.exec("SELECT book_id FROM books_authors WHERE author_id = #{ self.id };")
    results.each do |result|
      book_id = result.fetch("book_id").to_i
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      title = book.first.fetch("title")
      due_date = book.first.fetch("due_date")
      patron_id = book.first.fetch("patron_id").to_i
      book_authors.push(Book.new(:title => title, :id => book_id, :due_date => nil, :patron_id => patron_id))
    end
    book_authors
  end

  define_method(:duplicates) do
    results = []
    author_name = ""
    Author.all.each do |author|
      if (self.name == author.name)&&(self.id != author.id)
        results.push([author.name, author.id])
      end
    end
    results
  end

  define_method(:merge) do |author_to_merge|
    book_ids = []
    results = DB.exec("SELECT * FROM books_authors WHERE author_id = #{author_to_merge.id};")
    results.each do |results|
      book_ids.push(results.fetch("book_id").to_i)
    end
    book_ids.each do |book_id|
      DB.exec("INSERT INTO books_authors (author_id, book_id) VALUES (#{self.id}, #{book_id});")
    end
    author_to_merge.delete
  end

  define_singleton_method(:clear) do
    DB.exec("DELETE FROM authors *;")
  end
end
