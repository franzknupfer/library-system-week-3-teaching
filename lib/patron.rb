class Patron
  require 'date'
  require 'time'

  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def ==(other_patron)
    self.name == other_patron.name
  end

  def self.all
    patrons = []
    results = DB.exec("SELECT * FROM patrons;")
    results.each do |result|
      name = result.fetch("name")
      id = result.fetch("id").to_i
      patrons.push(Patron.new(:name => name, :id => id, :book_history => nil))
    end
    patrons
  end

  def save
    results = DB.exec("INSERT INTO patrons (name) VALUES ('#{self.name}') RETURNING id;")
    @id = results.first.fetch("id").to_i
  end

  def self.find(patron_id)
    found_patron = nil
    Patron.all.each do |patron|
      if patron.id == patron_id
        found_patron = patron
        break
      end
    end
    found_patron
  end

  def update(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE patrons SET name = '#{@name}' WHERE id = #{self.id};")
  end

  def delete
    DB.exec("DELETE from patrons WHERE id = #{self.id};")
  end

  def checkout(book)
    due_date = (DateTime.now + 14).to_time
    DB.exec("UPDATE books SET due_date = '#{due_date}' WHERE id = #{book.id};")
    DB.exec("UPDATE books SET patron_id = #{self.id} WHERE id = #{book.id};")
    DB.exec("INSERT INTO checkouts (patron_id, book_id, due_date) VALUES (#{self.id}, #{book.id}, '#{due_date}');")
  end

  def checked_out
    checked_out_books = []
    patron_id = self.id
    results = DB.exec("SELECT * FROM books WHERE patron_id = #{patron_id};")
    results.each do |result|
      due_date = result.fetch("due_date")
      title = result.fetch("title")
      id = result.fetch("id").to_i
      checked_out_books.push(Book.new(:title => title, :due_date => due_date, :id => id, :patron_id => patron_id))
    end
    checked_out_books
  end

  def book_history
    book_history = []
    patron_id = self.id
    results = DB.exec("SELECT * FROM checkouts WHERE patron_id = #{patron_id};")
    results.each do |result|
      due_date = result.fetch("due_date")
      book_id = result.fetch("book_id").to_i
      book = DB.exec("SELECT title FROM books WHERE id = #{book_id}")
      title = book.first.fetch("title")
      book_history.push(Book.new({:title => title, :due_date => due_date, :id => book_id, :patron_id => patron_id}))
    end
    book_history
  end

end
