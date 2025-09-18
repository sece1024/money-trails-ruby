require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get show" do
    get account_url(@account)
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference("Account.count") do
      post accounts_url, params: { account: { name: "Test Account", account_type: "asset", initial_balance: 100.0 } }
    end

    assert_redirected_to account_url(Account.last)
  end

  test "should get edit" do
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    patch account_url(@account), params: { account: { name: "Updated Account" } }
    assert_redirected_to account_url(@account)
    @account.reload
    assert_equal "Updated Account", @account.name
  end

  test "should destroy account" do
    assert_difference("Account.count", -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
  end

  test "should not access accounts without authentication" do
    sign_out
    get accounts_url
    assert_redirected_to new_session_url
  end
end
