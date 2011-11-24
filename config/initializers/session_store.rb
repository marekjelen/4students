# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
if ENV['RAILS_ENV'] == 'development'
  STUDENTS_DOMAIN = '4s.cz'
else
  STUDENTS_DOMAIN = '4students.cz'
end

ActionController::Base.session = {
        :domain      => ".#{STUDENTS_DOMAIN}",
        :key         => '_komunity_session',
        :secret      => '0302fbf567c304cc54bb3ab5f7a5a9068819206d2e50197cd301468974128825f8bdaf18a5320d77eea5107a4c7b79a6f547c91a4c60b0c043b9217531992ade'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store #:mem_cache_store