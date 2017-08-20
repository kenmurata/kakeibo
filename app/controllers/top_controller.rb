class TopController < ApplicationController
  def index
    
    # 入力フォーム作成
    @balance = Balance.new
    
    # 収支状況を表示する期間(設定パラメータを取得)
    start_date = SystemConfig.find_by(:name => 'start_date').value.to_i.ordinalize
    
    # 今月の支出状況作成
    @this_month_balances, @period_start, @period_end = self.class.helpers.get_this_month_balance(start_date)
    @summary =  self.class.helpers.calc_this_month_summary(@this_month_balances)
    category = ['収入','支出']

    @graph = LazyHighCharts::HighChart.new('column', :style => 'float:left;height:500px;width:500px;') do |f|
      
      # 横軸のラベル
      f.xAxis(categories: category)
      
      # 棒グラフの収入の部分
      f.series(:name => '給料', :data => [@summary[:income],])
      
      # 棒グラフの支出の部分
      @summary[:balance_class_sum].each do |bc|
        f.series(:name => bc[0], :data => [0,bc[1]])
      end
      
      f.options[:chart][:defaultSeriesType] = 'column'
      f.plot_options({:column => {stacking: 'normal'}})
    end
    
  end
end