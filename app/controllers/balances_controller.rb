class BalancesController < ApplicationController
  
  def index
    # ユーザによって表示期間が指定された場合はその期間のデータを元に表示
    if period_params[:start_date] && period_params[:end_date]
    
      start_date = Date.parse(period_params[:start_date])
      end_date = Date.parse(period_params[:end_date])
      # 今月の支出状況作成
      @this_month_balances, @period_start, @period_end = self.class.helpers.get_period_balance(start_date,end_date)
      @summary = self.class.helpers.calc_this_month_summary(@this_month_balances)
      
    # period_paramsが空なら、標準の(システム設定で規定された)1か月間のデータを元に表示
    else
      
      # 収支状況を表示する期間(設定パラメータを取得)
      start_date = SystemConfig.find_by(:name => 'start_date').value.to_i.ordinalize
      
      # 今月の支出状況作成
      @this_month_balances, @period_start, @period_end = self.class.helpers.get_this_month_balance(start_date)
      @summary = self.class.helpers.calc_this_month_summary(@this_month_balances)
      
    end
    
    # 棒グラフ
    @bar_graph = LazyHighCharts::HighChart.new('column', :style => 'float:left;height:500px;width:500px;') do |f|
      
      # 横軸のラベル
      f.xAxis(categories: ['収入','支出'])
      
      # 棒グラフの収入の部分
      f.series(:name => '給料', :data => [@summary[:income],])
      
      # 棒グラフの支出の部分
      @summary[:balance_class_sum].each do |bc|
        f.series(:name => bc[0], :data => [0,bc[1]])
      end
      
      f.options[:chart][:defaultSeriesType] = 'column'
      f.plot_options({:column => {stacking: 'normal'}})
    end
    
    ## 後から追加する機能：支出の分類を円グラフで表示
    @pie_graph = LazyHighCharts::HighChart.new('pie', :style => 'float:left;height:500px;width:500px;') do |f|
      f.chart({defaultSeriesType: 'pie'})
      f.series({
        type: 'pie',
        name: '金額',
        data: @summary[:balance_class_sum].to_a
      })
    end
  end
  
  def new
    @balance = Balance.new
  end
  
  
  ### 一括登録する時に入力欄を追加するアクション
  def add
    @balance = Balance.new
  end
  
  ### 一括登録するアクション
  def bulk_create
    balances = params.require(:balances).map{ |balance| balance.permit(:value, :column, :subject, :balance_type, :balance_date, :balance_class) }
    balances.each do |b|
      Balance.create b
    end
    redirect_to root_path
  end
  
  ### 1つだけ登録するアクション(TOPページ経由)
  def create
    balance = Balance.new(balance_params)
    
    # 保存
    if balance.save
      redirect_to root_path, notice: '支出を登録しました'
    else
      redirect_to root_path, alert: '登録に失敗しました'
    end
  end
  
  def destroy
    balance = Balance.find(params[:id])
    balance.delete
    redirect_to balances_path, notice: '削除しました'
  end
  
  private
    def balance_params
      params.fetch(:balance, {}).permit(:value, :column, :subject, :balance_type, :balance_date, :balance_class)
    end
    
    def period_params
      params.permit(:start_date, :end_date)
    end
end
