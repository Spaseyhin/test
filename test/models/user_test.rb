# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com', password: 'foobar',
                     password_confirmation: 'foobar')
  end
  test 'should be valid' do
    assert @user.valid?
  end
  test 'name should be present' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  test 'email should be present' do
    @user.email = "#{'a' * 244}@example.com"
    assert_not @user.valid?
  end
  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_addresses|
      @user.email = valid_addresses
      assert @user.valid?, "#{valid_addresses.inspect} should be valid"
    end
  end
  test 'email validation should reject invalid addresses' do
    valid_addresses = %w[user@example,com USERfoo.com A_US-ER@foo. foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be valid"
    end
  end
  test 'email addresses should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test 'password should have a minimum length ' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
