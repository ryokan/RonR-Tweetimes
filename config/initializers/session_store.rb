# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tweetimes_session',
  :secret      => 'c1cddf604fdaad80e0d3b84642cf3d685c15d3382d426d464594a943461f5c3b818bd4dc59b1096401092fc1afbf6e669231c9fcd9b7e4f803e0f286d275dee1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
