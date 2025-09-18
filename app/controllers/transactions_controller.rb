class TransactionsController < ApplicationController
  def index
    # 找到父级账户，并获取其所有交易
    @account = Current.user.accounts.find(params[:account_id])
    @transactions = @account.transactions.order(transaction_date: :desc)
  end

  def new
    # 找到父级账户，并为新交易创建实例
    @account = Current.user.accounts.find(params[:account_id])
    @transaction = @account.transactions.new
  end

  def create
    @account = Current.user.accounts.find(params[:account_id])
    @transaction = @account.transactions.new(transaction_params)
    @transaction.user = Current.user
    if @transaction.save
      redirect_to account_transactions_path(@account), notice: "交易记录成功！"
    else
      render :new
    end
  end

  private

  def transaction_params
    params.expect(transaction: [:description, :amount, :category, :transaction_date])
  end
end
