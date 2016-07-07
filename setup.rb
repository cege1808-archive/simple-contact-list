require 'pry' 
require 'active_record'
require_relative 'contact'
require_relative 'contact_list'

puts "Connect?"
# Output messages from Active Record to standard out
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

puts 'Setting up Database (recreating tables) ...'

# ActiveRecord::Schema.define do
#   drop_table :contact if ActiveRecord::Base.connection.table_exists?(:contact)
#   create_table :contact do |t|
#     t.column :name, :string
#     t.column :email, :string
#     t.timestamps null: false
#   end
  
# end

puts 'Setup DONE'
