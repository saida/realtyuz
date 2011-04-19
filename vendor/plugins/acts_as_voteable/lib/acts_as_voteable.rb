# ActsAsVoteable
module Juixe
  module Acts #:nodoc:
    module Voteable #:nodoc:

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_voteable
          has_many :votes, :as => :voteable, :dependent => :destroy
          include Juixe::Acts::Voteable::InstanceMethods
          extend Juixe::Acts::Voteable::SingletonMethods
        end
      end
      
      # This module contains class methods
      module SingletonMethods
        def find_votes_cast_by_account(account)
          voteable = ActiveRecord::Base.send(:class_name_of_active_record_descendant, self).to_s
          Vote.find(:all,
            :conditions => ["account_id = ? and voteable_type = ?", account.id, voteable],
            :order => "created_at DESC"
          )
        end
      end
      
      # This module contains instance methods
      module InstanceMethods
        def votes_for
          votes = Vote.find(:all, :conditions => [
            "voteable_id = ? AND voteable_type = ? AND vote = 1",
            id, self.type.name
          ])
          votes.size
        end
        
        def votes_against
          votes = Vote.find(:all, :conditions => [
            "voteable_id = ? AND voteable_type = ? AND vote = 0",
            id, self.type.name
          ])
          votes.size
        end
        
        # Same as voteable.votes.size
        def votes_count
          self.votes.size
        end
        
        def accounts_who_voted
          accounts = []
          self.votes.each { |v|
            accounts << v.account
          }
          accounts
        end
        
        def voted_by_account?(account)
          rtn = false
          if account
            self.votes.each { |v|
              rtn = true if account.id == v.account_id
            }
          end
          rtn
        end
      end
    end
  end
end
