require 'pry' 
require 'active_record'
require_relative 'contact'
# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList
  
  def display_mainmenu
    puts "Here is a list of available commands:"
    puts "\t new \t- Create a new contact"
    puts "\t list \t- List all contacts"
    puts "\t show \t- Show a contact"
    puts "\t search - Search contact"
    puts "\t update - Update contact"
    puts "\t delete - Delete contact"
    puts
  end

  def display_total_records(count)
    puts '-' * 3
    puts "#{count} records total"
  end
  
  def initialize
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    puts 'Establishing connection to database ...'
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      database: 'contacts',
      username: 'development',
      password: 'development',
      host: 'localhost',
      port: 5432
    )

    puts 'CONNECTED'
    display_mainmenu
  end

  def run
    
    case ARGV[0]
      when "list"
        contacts = Contact.all
        pp contacts
        display_total_records(contacts.count)

      when "new"
        puts "New Name?"
        new_name = STDIN.gets.chomp
        puts "New Email?"
        new_email = STDIN.gets.chomp

        res = Contact.new({'name' => new_name, 'email' => new_email})
        contact = res.save
        pp contact

      when "update"
        the_contact = Contact.find(ARGV[1])

        puts "Current  #{the_contact}"
        
        puts "New Name?"
        new_name = STDIN.gets.chomp
        puts "New Email?"
        new_email = STDIN.gets.chomp

        the_contact.name = new_name
        the_contact.email = new_email
        if the_contact.save
          puts "Now  #{the_contact}"
        else 
          puts "Contact did not save"
        end

      when "show"
        contact = Contact.find(ARGV[1])
        puts contact ? contact : "NOT FOUND"

      when "search"
        search_results = Contact.search(ARGV[1])
        pp search_results
        display_total_records(search_results.count)

      when "delete"
        the_contact = Contact.find(ARGV[1])
        name =the_contact.name
        the_contact.destroy
        puts "Contact #{name} deleted"
    end
  end

end

ContactList.new.run


