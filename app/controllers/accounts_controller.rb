class AccountsController < ApplicationController
  def index
    # 在这里获取所有账户，并传递给视图
    @accounts = Current.user.accounts.includes(:transactions)
    @total_asset_by_month = Current.user.snapshots.map { |snapshot| [ snapshot.snapshot_date.strftime("%Y年%m月"), snapshot.total_asset ] }
  end

  def show
    # 根据 ID 查找并显示单个账户
    @account = Current.user.accounts.find(params[:id])
  end

  def new
    # 创建一个新的账户实例，用于表单
    @account = Current.user.accounts.new
  end

  def create
    # 根据表单数据创建新账户
    @account = Current.user.accounts.new(account_params)
    if @account.save
      redirect_to @account, notice: "账户创建成功！"
    else
      render :new
    end
  end

  def edit
    @account = Current.user.accounts.find(params[:id])
  end

  def update
    @account = Current.user.accounts.find(params[:id])
    if @account.update(account_params)
      redirect_to @account, notice: "账户更新成功！"
    else
      render :edit
    end
  end

  def destroy
    @account = Current.user.accounts.find(params[:id])
    @account.destroy
    redirect_to accounts_path, notice: "账户删除成功！"
  end

  private

  # 定义强参数，防止恶意用户提交未经允许的字段
  def account_params
    params.require(:account).permit(:name, :account_type, :initial_balance)
  end
end
