# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_realestate_session',
  :secret      => '20df0574d125920fbe6f46af6123fbde13b956c89db1bfb2f5f1ea45940f5b612f7cc609bbd8efa304ec0b01a0fd98ccabbd60c46b21cb81d103c162b4f1d8fe',
  :expire_after => 60.minutes
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
