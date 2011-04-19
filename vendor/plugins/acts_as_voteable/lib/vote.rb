class Vote < ActiveRecord::Base

  # NOTE: Votes belong to an account
  belongs_to :account

  def self.find_votes_cast_by_account(account)
    find(:all,
      :conditions => ["account_id = ?", account.id],
      :order => "created_at DESC"
    )
  end
end