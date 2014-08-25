class Document < ActiveRecord::Base
  attr_accessible :file_name, :user, :quality

  belongs_to :user

  def self.for_user(user)
    Document.where(user_id: user.id)
  end
end
