require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    @transaction = transactions(:one)
    sign_in_as(@user)
  end

  test "should get index" do
    get account_transactions_url(@account)
    assert_response :success
  end

  test "should get new" do
    get new_account_transaction_url(@account)
    assert_response :success
  end

  test "should create transaction" do
    assert_difference("Transaction.count") do
      post account_transactions_url(@account), params: {
        transaction: {
          description: "Test Transaction",
          amount: 50.0,
          category: "Food",
          transaction_date: Date.current
        }
      }
    end

    assert_redirected_to account_transactions_url(@account)
  end

  test "should not access transactions without authentication" do
    sign_out
    get account_transactions_url(@account)
    assert_redirected_to new_session_url
  end

  test "should not access other user's account transactions" do
    other_user = users(:two)
    other_account = accounts(:two)

    get account_transactions_url(other_account)
    assert_response :not_found
  end
end
