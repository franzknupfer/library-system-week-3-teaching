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
      patrons.push(Patron.new(:name => name, :id => id))
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
    DB.exec("INSERT INTO checkouts (due_date, patron_id, book_id) VALUES ('#{due_date}', #{self.id}, #{book.id});")
  end

  def checked_out
    checked_out_books = []
    results = DB.exec("SELECT book_id, due_date FROM checkouts WHERE patron_id = #{self.id};")
    results.each do |result|
      book_id = result.fetch("book_id").to_i
      due_date = Time.parse(result.fetch("due_date")).strftime("%m/%d/%Y")
      book = DB.exec("SELECT * FROM books WHERE id = #{book_id};")
      checked_out_books.push([book, due_date])
    end
    checked_out_books
  end

end
