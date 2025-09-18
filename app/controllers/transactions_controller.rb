class TransactionsController < ApplicationController
  def index
    # 找到父级账户，并获取其所有交易
    @account = Account.find(params[:account_id])
    @transactions = @account.transactions
  end

  def new
    # 找到父级账户，并为新交易创建实例
    @account = Account.find(params[:account_id])
    @transaction = @account.transactions.new
  end

  def create
    @account = Account.find(params[:account_id])
    @transaction = @account.transactions.new(transaction_params)
    if @transaction.save
      redirect_to account_transactions_path(@account), notice: "交易记录成功！"
    else
      render :new
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:description, :amount, :category, :transaction_date)
  end
end
