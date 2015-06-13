require 'test_helper'
require 'shoulda-matchers'

class UserTest < ActiveSupport::TestCase
  # General Validations
  %i(email password full_name).each do |field|
    should validate_presence_of field
  end

  [:full_name].each do |field|
    [
      'John', 'Smith:', 'Rick.Smith-Smthy', %('Singlequotes'),
      'Frénchç', 'Âürman', 'Fẽr۩st', 'Arصbڸic', 'Hebהreךw',
      '123456', '***', '^', %("doublequotes"), 'B%bby',
      'J#n*s', 'Bobb☆y', 'Jo¶ns'
    ].each do |word|
      should allow_value(word).for(field)
    end

    %w(dave@some @me.com).each do |word|
      should_not allow_value(word).for(field).
        with_message('cannot contain an email address')
    end

    %w(http://website ftp://something https://secure.com www.website.com).each do |word|
      should_not allow_value(word).for(field).with_message('cannot contain a URL')
    end
  end

  # Email format validation
  %w(John@one.com Jane.Smith+20@gmail.com Rick.Smith-Smthy@yahoo.co.uk).each do |word|
    should allow_value(word).for(:email)
  end

  ['123456', '@', '@gmail.com', 'fdjkfsd', 'dave@', 'one@abce'].each do |word|
    should_not allow_value(word).for(:email)
  end

  # Email uniqueness validation
  describe 'unique user email' do
    let(:subject) { User.new full_name: 'John Smith' }
    should validate_uniqueness_of(:email).case_insensitive
  end

  # Password validation
  should validate_length_of(:password).is_at_least(8).is_at_most(72)

  it 'should require confirmation to be set when creating a new record' do
    pass = '123new_password'
    user = User.new password: pass,
                    password_confirmation: 'blabla'

    user.wont_be :valid?
    user.errors[:password_confirmation].join.must_equal "doesn't match Password"

    user = User.new full_name: 'John Smith',
                    email: 'john@mailinator.com',
                    password: pass,
                    password_confirmation: pass

    user.must_be :valid?
  end

  # Miscellaneous
  it 'has a valid factory' # might be achieved with FactoryGirl.lint ?

  it "should encrypt user's password" do
    user = User.new password: 'Secret765'
    enc = user.encrypted_password
    enc.must_be :present?
    enc.wont_equal 'Secret765'
    enc.length.must_equal 60
  end

  #
  # class Destruction < ActiveSupport::TestCase
  #   it 'can be destroyed' do
  #     expect {
  #       u = create(:user)
  #       u.destroy
  #
  #       User.count.should == 0
  #     }.to_not raise_error
  #   end
  #
  #   it 'it destroys user dependencies'
  # end
end
