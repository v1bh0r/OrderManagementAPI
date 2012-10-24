require 'spec_helper'

describe LineItem do
  before(:each) do
    @order = Order.create!(status: 'DRAFT', order_date: Date.current)
    @product = Product.create!(:name => 'My Product', :price => 50.25)
    @line_item = LineItem.create!(order_id: @order.id, product_id: @product.id, quantity: 50)
  end

  it { should belong_to :order }
  it { should belong_to :product }
  it { should validate_numericality_of :quantity }
  it { should validate_presence_of :order_id }
  it { should validate_presence_of :product_id }
  it { should validate_presence_of :quantity }

  it "should validate quantity to be > 0" do
    @line_item.quantity = 0
    @line_item.should be_invalid
    @line_item.quantity = -1
    @line_item.should be_invalid
    @line_item.quantity = 1
    @line_item.should be_valid
  end
end
