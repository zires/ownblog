# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_zblog_session',
  :secret      => 'd11a45130aa3eb3b11b782896bdf452dc02d46025ff4033ca0d4acea17e3d6152c753d287150a4348b7f78eb5d3a3c3c97a4e386f67bf6d34c62323f5bfd1e7f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
