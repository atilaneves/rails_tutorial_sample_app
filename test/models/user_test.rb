require 'test_helper'

# User tests
class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = '           '
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = '   '
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w(user@example.com USER@foo.com A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn)
    valid_addresses.each do |addr|
      @user.email = addr
      assert @user.valid?, '#{addr.inspect} should be valid'
    end
  end

  test 'email validation should reject invalid addresses' do
    addrs = %w(user@example,com user_at_foo.org user.name@example.
               foo@bar_baz.com foo@bar+baz.com)
    addrs.each do |addr|
      @user.email = addr
      assert_not @user.valid?, '#{addr.inspect} should be invalid'
    end
  end

  test 'email addresses should be unique' do
    dup = @user.dup
    dup.email = @user.email.upcase
    @user.save
    assert_not dup.valid?
  end

  test 'password should be present' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should have minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end

  test 'authenticated? should be base for user with nil digets' do
    assert_not @user.authenticated?(:remember, '')
  end

  test 'associated microposts should be destroyed' do
    @user.save
    @user.microposts.create!(content: 'Lorem ipsum')
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
end
