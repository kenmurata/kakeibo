class Balance < ActiveRecord::Base
  validates :column, :value, :balance_class,  presence: true
  validates :value, numericality: true
  
  # 分類が存在しなければ登録する(Lineから登録される場合を想定)
  BalanceClass.find_or_create_by(:balance_class => :balance_class) do |bc|
    bc.balance_type = :balance_type
  end
end