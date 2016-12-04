require 'spec_helper'

describe(Patron) do
  describe("#==") do
    it("compares two patrons with the same name as equal") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron2 = Patron.new({:name => "Franz Knupfer", :id => nil})
      expect(patron1).to(eq(patron2))
    end
  end

  describe(".all") do
    it("returns an empty array at first") do
      expect(Patron.all).to(eq([]))
    end
  end

  describe("#id") do
    it("sets an ID when saved") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron1.save
      expect(patron1.id).to(be_an_instance_of(Fixnum))
    end
  end

  describe("#save") do
    it("saves a patron") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron1.save
      expect(Patron.all).to(eq([patron1]))
    end
  end

  describe(".find") do
    it("finds a patron by id") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron1.save
      patron2 = Patron.new({:name => "Chunch Face", :id => nil})
      patron2.save
      expect(Patron.find(patron2.id)).to(eq(patron2))
    end
  end

  describe("#update") do
    it("updates a patron") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron1.save
      patron1.update({:name => "Chunch Face"})
      expect(patron1.name).to(eq("Chunch Face"))
    end
  end

  describe("#delete") do
    it("deletes a patron") do
      patron1 = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron1.save
      patron2 = Patron.new({:name => "Chunch Sauce", :id => nil})
      patron2.save
      patron1.delete
      expect(Patron.all).to(eq([patron2]))
    end
  end

  describe("#checkout") do
    it("allows a patron to check out a book") do
      patron = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron.save
      book1 = Book.new({:title => "The Nix", :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      patron.checkout(book1)
      patron.checkout(book2)
      expect(patron.checked_out).to(eq([book1, book2]))
    end
  end

  describe("#checked_out") do
    it("shows all books a patron has checked out") do
      patron = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron.save
      book1 = Book.new({:title => "The Nix", :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      patron.checkout(book1)
      patron.checkout(book2)
      expect(patron.checked_out).to(eq([book1, book2]))
    end
  end

  describe("#book_history") do
    it("shows a patron's book history") do
      patron = Patron.new({:name => "Franz Knupfer", :id => nil})
      patron.save
      book1 = Book.new({:title => "The Nix", :id => nil, :due_date => nil, :patron_id => nil})
      book1.save
      book2 = Book.new({:title => "Never Let Me Go", :id => nil, :due_date => nil, :patron_id => nil})
      book2.save
      patron.checkout(book1)
      patron.checkout(book2)
      expect(patron.book_history).to(eq([book1, book2]))
    end
  end

end
