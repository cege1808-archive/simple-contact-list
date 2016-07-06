require 'pg'
TABLE_NAME = 'contacts'

#TODO make sure everything is an okay response
class Contact

  attr_reader :id
  attr_accessor :name, :email
  
  def initialize(params)
    @id = params['id']
    @name = params['name']
    @email = params['email']
  end

  def to_s
    "#{id}: #{name} (#{email})"
  end

  def is_saved?
    @id != nil
  end

  def save
    if is_saved?
      res = Contact.connection.exec_params(
        "UPDATE #{TABLE_NAME} 
        SET name = $2, email = $3 WHERE id = $1 
        RETURNING id, name, email;", 
        [id, name, email])

      #get the data from the database
      @id = res[0]['id']
      @name = res[0]['name']
      @email = res[0]['email']

    else
      res = Contact.connection.exec_params(
        "INSERT INTO #{TABLE_NAME} (name, email) 
        VALUES ($1, $2) 
        RETURNING id, name, email;", 
        [name, email])

      Contact.new(res[0])
    end
  end

  def destroy
    Contact.connection.exec_params("DELETE FROM #{TABLE_NAME} WHERE id = $1;", [id])
  end


  # Provides functionality for managing contacts in the database
  class << self

    # Connection 
    def connection
      @@connection = nil
      # puts 'Connecting to the database...'
      @@connection = @@connection || PG.connect(
        host: 'localhost',
        dbname: 'contacts',
        user: 'development',
        password: 'development')
    end

    # Display everything in the database
    def all
      res = self.connection.exec_params(
        "SELECT * FROM #{TABLE_NAME}")
      res.map do |row|
        Contact.new(row)
      end
    end

    # Find contacts by id
    def find(id)
      res = self.connection.exec_params(
        "SELECT * FROM #{TABLE_NAME} 
        WHERE id = $1::int;",[id])
      return nil if res.num_tuples == 0
      Contact.new(res[0])
    end
    
    # Search for contacts by either name or email.
    def search(term)
      res = self.connection.exec_params(
        "SELECT * FROM #{TABLE_NAME} 
        WHERE (name LIKE '%' || $1 || '%') OR 
        (email LIKE '%' || $1 || '%');",[term])
      res.map do |row|
        Contact.new(row)
      end
    end

  end

end