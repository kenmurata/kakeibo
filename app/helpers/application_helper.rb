module ApplicationHelper
  
  ### 現在の収支データを取得するメソッド
  def get_this_month_balance(start_date)
    if Date.today >= Date.parse(start_date)
      period_start = Date.parse(start_date)
      period_end = Date.parse(start_date) + 1.month
    else
      period_start = Date.parse(start_date) - 1.month
      period_end = Date.parse(start_date) - 1.day
    end
    return Balance.where('balance_date between ? and ?', period_start, period_end).order("balance_date DESC"), period_start, period_end
  end
  
  ### ある期間の収支データを取得するメソッド
  def get_period_balance(start_date, end_date)
    return Balance.where('balance_date between ? and ?', start_date, end_date).order("balance_date DESC"), start_date, end_date
  end
  
  ### 支出のデータを加工して必要な情報を取得するメソッド
  # 得られる情報は
  # (1) 収入/支出の合計
  # (2) 支出の項目毎の合計
  def calc_this_month_summary(balances)
    income = 0
    payment = 0
    balance_classes = []
    balance_class_sum = {}
  
    # 収入、支出の合計を出す
    balances.each do |b|
      if b.balance_type == true
        income = income + b.value
      else
        payment = payment + b.value
      end
    end
    
    # 支出の分類ごとに合計を出す
    # まず分類の一覧を取得
    balances.each do |b|
      if ! balance_classes.include?(b.balance_class) && b.balance_type == false
        balance_classes.push(b.balance_class)
      end
    end
    
    # 支出の分類ごとにループ
    balance_classes.each do |c|
     
      # 各支出分類ごとの合計金額を算出
      tmp_val = 0
      balances.each do |b|
        if b.balance_type == false && c == b.balance_class
          tmp_val += b.value 
        end
      end
      
      # hashにして返す
      balance_class_sum.store(c, tmp_val)
    end
    
    summary = {'income': income, 'payment': payment, 'balance_class_sum': balance_class_sum}
    return summary
  end
end
