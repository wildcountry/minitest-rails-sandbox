require 'test_helper'

class UserTest < ActiveSupport::TestCase
  ## General Validations
  %i(email password full_name).each do |field|
    should validate_presence_of field
  end

  # %i(first_name last_name).each do |field|
  %i(full_name).each do |field|
    [
      'John', 'Smith:', 'Rick.Smith-Smthy', %('Singlequotes'),
      'Frénchç', 'Âürman', 'Fẽr۩st', 'Arصbڸic', 'Hebהreךw', 'Bobb☆y',
      '123456', '***', '^', %("doublequotes"), 'B%bby', 'J#n*s', 'Jo¶ns'
    ].each do |word|
      should allow_value(word).for(field)
    end

    %w(dave@some @me.com test@example.com).each do |word|
      should_not allow_value(word).for(field).
        with_message('cannot contain an email address')
    end

    %w(http://website ftp://something https://secure.com www.website.com).each do |word|
      should_not allow_value(word).for(field).with_message('cannot contain a URL')
    end
  end

  ## Email format validation
  %w(John@one.com Jane.Smith+20@gmail.com Rick.Smith-Smthy@yahoo.co.uk
     Fẽr۩st@Arصbڸic.com bob☆y.Âürman@fénchç.fr).each do |word|
    should allow_value(word).for(:email)
  end

  ['123456', '@', '@gmail.com', 'fdjkfsd', 'dave@', 'one@abce'].each do |word|
    should_not allow_value(word).for(:email)
  end

  ## Password validation
  should validate_length_of(:password).is_at_least(8).is_at_most(72)

  it 'should require confirmation to be set when creating a new record' do
    pass = '123new_password'
    user = build_stubbed :user, password: pass, password_confirmation: 'blabla'

    user.wont_be :valid?
    user.errors[:password_confirmation].join.must_equal "doesn't match Password"

    user = build_stubbed :user, password: pass, password_confirmation: pass

    user.must_be :valid?
  end

  ## Miscellaneous
  it "should encrypt user's password" do
    pass = 'Secret765'
    user = User.new password: pass

    enc = user.encrypted_password
    enc.must_be :present?
    enc.wont_equal pass
    enc.length.must_equal 60
  end

  ## Destruction
  it 'can be destroyed' do
    u = create :user

    expect { u.destroy }.must_change 'User.count', -1
  end

  it 'destroys user dependencies' # pending
end

class UserUniquenessTest < ActiveSupport::TestCase
  ## User email uniqueness validation
  let(:subject) { build :user }

  should validate_uniqueness_of(:email).case_insensitive
end
