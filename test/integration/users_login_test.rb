require 'test_helper'

# Tests for login
class UsersLoginTest < ActionDispatch::IntegrationTest
  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path session: { email: '', password: '' }
    assert_template 'sessions/new' # should go back to login page
    assert_not flash.empty?, 'red flash with error message'
    get root_path
    assert flash.empty?, 'the error message should be gone'
  end
end
