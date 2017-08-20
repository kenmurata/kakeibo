class SystemConfigsController < ApplicationController
  
  def index
    
    # 月の開始日に必要な変数
    @start_date = SystemConfig.find_by(:name => 'start_date')
    @day = []
    for i in 1..31 do 
      @day.push [i, "#{i}"]
    end
    
    # 分類登録に必要な変数
    @balance_classes = BalanceClass.all
    @new_balanceclass = BalanceClass.new
  end
  
  def update
    systemconfig = SystemConfig.find(params[:id])
    systemconfig.value = systemconfig_params[:value]
    if systemconfig.save
      redirect_to root_path, notice: '変更しました'
    else
      redirect_to root_path, notice: '変更に失敗しました'
    end
  end
  
  private
    def systemconfig_params
      params.require(:system_config).permit(:value, :name)
    end
end