require 'spec_helper'

describe Document do
  let(:bob) { User.create(name: 'bob', email: 'bob@example.com', password: 'abcd1234') }
  let(:jane) { User.create(name: 'jane', email: 'jane@example.com', password: 'abcd1234') }

  before :each do
    {'one' => bob, 'two' => jane, 'three' => bob}.each do |name, user|
      d = Document.new(file_name: name)
      d.user = user
      d.save!
    end
  end

  describe :for_user do
    it 'finds all documents for the given user' do
      Document.for_user(bob).length.should== 2
    end

    it 'only finds documents for the given user' do
      Document.for_user(bob).each do |d|
        d.user.should== bob
      end
    end
  end
end
