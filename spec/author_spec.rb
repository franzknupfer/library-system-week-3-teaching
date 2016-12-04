require 'spec_helper'

describe(Author) do
  describe("#==") do
    it("compares two authors with the same name as equal") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author2 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
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
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author1.save
      expect(author1.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("saves a author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author1.save
      expect(Author.all).to(eq([author1]))
    end
  end

  describe(".find") do
    it("finds a author by id") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author1.save
      author2 = Author.new({:name => "Jonathan Lethem", :id => nil})
      author2.save
      expect(Author.find(author2.id)).to(eq(author2))
    end
  end

  describe("#update") do
    it("updates an author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author1.save
      author1.update({:name => "Haruki Murakami"})
      expect(author1.name).to(eq("Haruki Murakami"))
    end
  end

  describe("#delete") do
    it("deletes an author") do
      author1 = Author.new({:name => "Kazuo Ishiguro", :id => nil})
      author1.save
      author2 = Author.new({:name => "Jonathan Lethem", :id => nil})
      author2.save
      author1.delete
      expect(Author.all).to(eq([author2]))
    end
  end

  describe("#update") do
    it("lets you add a book to an author") do
      author = Author.new({:name => 'Daniel Clowes', :id => nil})
      author.save
      book1 = Book.new({:title => 'Ghost World', :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      book2 = Book.new({:title => 'Patience', :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      author.update({:book_ids => [book1.id, book2.id]})
      expect(author.books).to(eq([book1, book2]))
    end
  end

  describe("#books") do
    it("lists all books of a author") do
      author = Author.new({:name => 'Daniel Clowes', :id => nil})
      author.save
      book1 = Book.new({:title => 'Ghost World', :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      book2 = Book.new({:title => 'Patience', :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      author.update({:book_ids => [book1.id, book2.id]})
      expect(author.books).to(eq([book1, book2]))
    end
  end

  describe("#duplicates") do
    it("returns whether the author is a duplicate") do
      author = Author.new({:name => 'Daniel Clowes', :id => nil})
      author.save
      author2 = Author.new({:name => 'Daniel Clowes', :id => nil})
      author2.save
      expect(author2.duplicates).to(eq([[author.name, author.id]]))
    end
  end

  describe("#merge") do
    it("merges two duplicate authors") do
      author = Author.new({:name => 'Daniel Clowes', :id => nil})
      author.save
      book1 = Book.new({:title => 'Ghost World', :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      author.update({:book_ids => [book1.id]})
      author2 = Author.new({:name => 'Daniel Clowes', :id => nil})
      author2.save
      book2 = Book.new({:title => 'Patience', :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      book3 = Book.new({:title => 'Like a Velvet Glove Cast in Iron', :id => nil, :due_date => nil, :patron_id => nil})
      book3.save
      author2.update({:book_ids => [book2.id, book3.id]})
      author.merge(author2)
      expect(Author.all).to(eq([author]))
      expect(author.books).to(eq([book1, book2, book3]))
    end
  end
end
