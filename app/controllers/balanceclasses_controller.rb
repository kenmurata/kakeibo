class BalanceclassesController < ApplicationController
  
  def create
    
    # パラメータを代入
    n = BalanceClass.new
    n.balance_class = balanceclass_params[:balance_class]
    n.balance_type = balanceclass_params[:balance_type]
    
    # 保存する
    if n.save
      redirect_to root_path, notice: '登録しました'
    else
      redirect_to root_path, alert: '登録失敗しました'
    end
  end
  
  def destroy
    balanceclass = BalanceClass.find(params[:id])
    if balanceclass.delete
      redirect_to root_path, notice: '消しましたー'
    end
  end
  
  private
    def balanceclass_params
      params.require(:balance_class).permit(:balance_class, :balance_type)
    end
end
