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
      book1 = Book.new({:title => "The Nix", :id => nil})
      book2 = Book.new({:title => "The Nix", :id => nil})
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
      book1 = Book.new({:title => "The Nix", :id => nil})
      book1.save
      expect(book1.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("saves a book") do
      book1 = Book.new({:title => "The Nix", :id => nil})
      book1.save
      expect(Book.all).to(eq([book1]))
    end
  end

  describe(".find") do
    it("finds a book by id") do
      book1 = Book.new({:title => "The Nix", :id => nil})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil})
      book2.save
      expect(Book.find(book2.id)).to(eq(book2))
    end
  end

  describe("#update") do
    it("updates a book") do
      book1 = Book.new({:title => "The Nix", :id => nil})
      book1.save
      book1.update({:title => "Fortress of Solitude"})
      expect(book1.title).to(eq("Fortress of Solitude"))
    end
  end

  describe("#update") do
    it("adds an author to a book") do
      book = Book.new({:title => "Fortress of Solitude", :id => nil})
      book.save
      author = Author.new(:name => "Jonathan Lethem", :id => nil)
      author.save
      book.update({:author_ids => [author.id]})
      expect(book.authors).to(eq([author]))
    end
  end

  describe("#delete") do
    it("deletes a book") do
      book1 = Book.new({:title => "The Nix", :id => nil})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil})
      book2.save
      book1.delete
      expect(Book.all).to(eq([book2]))
    end
  end

  describe("#authors") do
    it("adds an author to a book") do
      book = Book.new({:title => "Fortress of Solitude", :id => nil})
      book.save
      author = Author.new(:name => "Jonathan Lethem", :id => nil)
      author.save
      book.update({:author_ids => [author.id]})
      expect(book.authors).to(eq([author]))
    end
  end

end
