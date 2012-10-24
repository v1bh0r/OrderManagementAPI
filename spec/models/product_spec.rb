require 'spec_helper'

describe Product do
  before(:each) { @product = Product.create!(:name => 'My Product', :price => 50.25) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:price) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_numericality_of(:price) }
  it { should have_many :line_items }
  it { should have_many :orders }

  it "should not allow destruction if belongs to an order" do
    order = Order.create!(status: 'DRAFT', order_date: Date.current)
    line_item = LineItem.create!(order_id: order.id, product_id: @product.id, quantity: 50)
    @product.destroy.should be_false

    product2 = Product.create!(:name => 'My Product2', :price => 53)
    product2.destroy.should be_true
  end
end
