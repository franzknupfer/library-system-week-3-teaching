require("rspec")
require("pg")
require("book")
require("author")
require("patron")
require("pry")

DB = PG.connect({:dbname => 'library_test'})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM checkouts *;")
    DB.exec("DELETE FROM books_authors *;")
  end
end
