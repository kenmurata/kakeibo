class Balance < ActiveRecord::Base
  validates :column, :value, :balance_class,  presence: true
  validates :value, numericality: true
  
  before_save :balance_class_find_or_create
  # 分類が存在しなければ登録する(Lineから登録される場合を想定)
  def balance_class_find_or_create
    balanceclass = self.balance_class
    BalanceClass.find_or_create_by(:balance_class => balanceclass) do |bc|
      bc.balance_type = self.balance_type
    end
  end
end