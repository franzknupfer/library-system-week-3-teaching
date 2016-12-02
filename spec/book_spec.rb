require("rspec")
require("pg")
require("book")
require("author")
require("pry")

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
  end
end

describe(Book) do
  describe("#==") do
    it("compares two books with the same name as equal") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book2 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      expect(book1).to(eq(book2))
    end
  end

  describe(".all") do
    it("returns an empty array at first") do
      expect(Book.all).to(eq([]))
    end
  end

  describe("#id") do
    it("sets an ID when saved") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book1.save
      expect(book1.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("saves a book") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book1.save
      expect(Book.all).to(eq([book1]))
    end
  end

  describe(".find") do
    it("finds a book by id") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil, :author_id => 1})
      book2.save
      expect(Book.find(book2.id)).to(eq(book2))
    end
  end

  describe("#update") do
    it("updates a book") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book1.save
      book1.update({:title => "Fortress of Solitude"})
      expect(book1.title).to(eq("Fortress of Solitude"))
    end
  end

  describe("#delete") do
    it("deletes a book") do
      book1 = Book.new({:title => "The Nix", :id => nil, :author_id => 1})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil, :author_id => 1})
      book2.save
      book1.delete
      expect(Book.all).to(eq([book2]))
    end
  end

  describe("#authors") do
    it("lists all authors of a book") do
      book = Book.new({:title => "Never Let Me Go", :id => nil, :author_id => 1})
      book.save
      author = Author.new({:name => "Kazuo Ishiguro", :id => nil, :book_id => book.id })
      author.save
      expect(book.authors).to(eq([author]))
    end
  end

end
