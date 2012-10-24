# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

20.times do |index|
  Product.create! :name => "product_#{index}", :price => rand(1..100)
end


o1 = Order.create! :order_date => Date.current
o2 = Order.create! :order_date => 2.days.from_now.to_date
o3 = Order.create! :order_date => 5.days.from_now.to_date

Product.all(:limit => 5).each do |product|
  o1.line_items.create! product_id: product.id, quantity: rand(1..1000)
end

Product.all(:limit => 5, :offset => 5).each do |product|
  item = o2.line_items.create! product_id: product.id, quantity: rand(1..1000)
end
o2.status = 'PLACED'
o2.save!
