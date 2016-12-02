require("rspec")
require("pg")
require("author")
require("book")
require("pry")

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM authors *;")
  end
end

describe(Author) do
  describe("#==") do
    it("compares two authors with the same name as equal") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author2 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      expect(author1).to(eq(author2))
    end
  end

  describe(".all") do
    it("returns an empty array at first") do
      expect(Author.all).to(eq([]))
    end
  end

  describe("#id") do
    it("sets an ID when saved") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author1.save
      expect(author1.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("saves a author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author1.save
      expect(Author.all).to(eq([author1]))
    end
  end

  describe(".find") do
    it("finds a author by id") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author1.save
      author2 = Author.new({:name => "Jonathan Lethem", :id => nil, :book_id => 1})
      author2.save
      expect(Author.find(author2.id)).to(eq(author2))
    end
  end

  describe("#update") do
    it("updates an author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author1.save
      author1.update({:name => "Haruki Murakami"})
      expect(author1.name).to(eq("Haruki Murakami"))
    end
  end

  describe("#delete") do
    it("deletes an author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1})
      author1.save
      author2 = Author.new({:name => "Jonathan Lethem", :id => nil, :book_id => 1})
      author2.save
      author1.delete
      expect(Author.all).to(eq([author2]))
    end
  end

  describe("#update") do
    it("lets you add a book to an author") do
      author = Author.new({:name => 'Daniel Clowes', :id => nil, :book_id => 1})
      author.save
      book1 = Book.new({:title => 'Ghost World', :id => nil, :author_id => 1})
    end
  end

  describe("#books") do
    it("lists all books of a author") do
      author = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => 1 })
      author.save
      book = Book.new({:title => "The Sleeping Giant", :id => nil, :author_id => author.id })
      book.save
      expect(author.books).to(eq([book]))
    end
  end

end
