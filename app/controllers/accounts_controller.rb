class AccountsController < ApplicationController
  def index
    # 在这里获取所有账户，并传递给视图
    @accounts = Account.all
  end

  def show
    # 根据 ID 查找并显示单个账户
    @account = Account.find(params[:id])
  end

  def new
    # 创建一个新的账户实例，用于表单
    @account = Account.new
  end

  def create
    # 根据表单数据创建新账户
    @account = Account.new(account_params)
    if @account.save
      redirect_to @account, notice: "账户创建成功！"
    else
      render :new
    end
  end

  # ... (编辑、更新和删除的方法类似，这里省略)

  private

  # 定义强参数，防止恶意用户提交未经允许的字段
  def account_params
    params.require(:account).permit(:user_id, :name, :type, :initial_balance)
  end
end
