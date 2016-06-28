require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, id = nil)
    @name = name
    @email = email
    @id = id
  end

  def to_s
    "#{id}: #{name} (#{email})"
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      contacts = []
      CSV.foreach('contact_list.csv') do |row|
        contacts << Contact.new(row[1], row[2], row[0])
      end
      contacts
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, id)
      new_id = CSV.read('contact_list.csv').length + 1
      contact = self.new(name, email, new_id)
      CSV.open('contact_list.csv', 'a') do |row|
        row << [contact.id, contact.name, contact.email]
      end
      contact
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      CSV.foreach('contact_list.csv') do |row|
        if row[0] == id
          return Contact.new(row[1], row[2], row[0])
        end
      end
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      all_rows = CSV.read('contact_list.csv')
      result_rows = all_rows.find_all do |row|
        row.any? do |word|
          word.include?(term)
        end
      end
      result_rows.map do |row|
        Contact.new(row[1], row[2], row[0])
      end

      # # CSV.foreach('contact_list.csv').with_index(1) do |row, index|
        
      # end
      # "NOT FOUND!"
      # # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
    end

  end

end