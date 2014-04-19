require 'digest/md5'

module Md5Helper
  def md5_hash(data)
    Digest::MD5.hexdigest data
  end
end