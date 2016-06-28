require_relative 'contact'




# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  
  def display_mainmenu
    puts "Here is a list of available commands:"
    puts "\t new \t- Create a new contact"
    puts "\t list \t- List all contacts"
    puts "\t show \t- Show a contact"
    puts "\t search - Search contact"
    puts
  end

  def display_total_records(count)
    puts '-' * 3
    puts "#{count} records total"
  end
  
  def initialize
    display_mainmenu
  end

  def run
    # puts ARGV
    
    case ARGV[0]
      when "list"
        contacts = Contact.all
        puts contacts
        display_total_records(contacts.count)

      when "new"
        puts Contact.create(ARGV[2], ARGV[3], ARGV[1])
        
      when "show"
        contact = Contact.find(ARGV[1])
        puts contact ? contact : "NOT FOUND"

      when "search"
        search_results = Contact.search(ARGV[1])
        puts search_results
        display_total_records(search_results.count)
    end
  end

end

ContactList.new.run


