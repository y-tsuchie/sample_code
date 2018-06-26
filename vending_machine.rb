# 自動販売機クラス
class VendingMachine
  attr_reader :remaining_money

  def initialize
    @remaining_money = 0 #残金
  end

  # お金の投入処理
  def charge(received_money:)
    # 取り扱える硬貨・紙幣かチェック
    if available_money.include?(received_money)
      @remaining_money += received_money
      puts "#{received_money}円投入されました。残金#{remaining_money}円です。"
    else
      puts "投入した#{received_money}は取り扱いできない硬貨・紙幣です。"
    end
  end

  # 現在の残金、ジュースの在庫から購入可能なジュースを表示する
  def show_available_juices
    puts '購入可能なジュースです。'
    puts "残金: #{remaining_money}円"
    puts '############################'
    available_juices.each { |juice| puts "#{juice.name}: #{juice.price}円" }
    puts '############################'
  end

  # 選択されたジュースの購入処理
  def sell(juice_name:)
    selected_juice = juices.find {|juice| juice.name == juice_name }
    return puts "#{juice_name}は、在庫がないか、取り扱っていないジュースです。" unless available?(selected_juice)
    change = remaining_money - selected_juice.price
    if change >= 0
      @remaining_money = change
      selected_juice.decrease
      puts "あなたは#{selected_juice.name}を買いました。残金は#{remaining_money}円です。"
    else
      puts "金額が足りませんでした"
    end
  end

  # おつりを払う（日本語おかしい気がする？）
  def pay_change
    puts "おつりは#{remaining_money}円です。"
    @remaining_money = 0
  end

  private

  # 現在の残金、ジュースの在庫から購入可能なジュースを返す
  def available_juices
    juices.reject { |juice| juice.price > remaining_money || juice.stock.zero? }
  end

  # 販売可能なジュースか？
  def available?(selected_juice)
    return false if selected_juice.nil?
    available_juices.any? { |juice| juice.name == selected_juice.name }
  end

  # 取り扱い可能な硬貨・紙幣
  def available_money
    [10, 50, 100, 500, 1000]
  end

  # 自動販売機のジュース
  def juices
    @juices ||= [
      Juice.new(name: 'orange', price: 100, stock: 10),
      Juice.new(name: 'cola', price: 150, stock: 10),
      Juice.new(name: 'cola_zero', price: 150, stock: 10),
    ]
  end
end

# ジュースクラス
class Juice
  attr_reader :name, :price, :stock

  def initialize(name: , price:, stock:)
    @name = name
    @price = price
    @stock = stock
  end

  def decrease
    @stock -= 1
  end
end

machine = VendingMachine.new
machine.charge(received_money: 100)
machine.show_available_juices
machine.charge(received_money: 100)
machine.show_available_juices
machine.sell(juice_name: 'orange')
machine.pay_change
