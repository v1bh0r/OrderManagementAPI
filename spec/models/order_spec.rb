require 'spec_helper'

describe Order do

  before(:each) { @order = Order.create!(status: 'DRAFT', order_date: Date.current) }

  it "cannot be deleted" do
    order = Order.create :order_date => Time.now, :status => 'DRAFT'
    order.destroy.should be_false
    order.delete.should be_false
    Order.delete_all.should be_false
  end

  it { should have_many(:line_items) }
  it { should have_many(:products) }

  it "can have customizable order date. But not in past" do
    @order.order_date = 2.days.from_now
    @order.should be_valid
    @order.order_date = 1.minute.ago
    @order.should be_invalid
  end

  it "status can be 'bumped' order from DRAFT to PLACED, but only if there is at least one line item" do
    product = Product.create :name => 'My Product', :price => 123
    @order.line_items.create :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.should be_valid
  end

  it "status can change from DRAFT to CANCELLED, when this happens a short reason must be provided" do
    @order.status = 'CANCELLED'
    @order.should be_invalid
    @order.status_update_reason = 'Some excuse'
    @order.should be_valid
  end

  it "status can change from PLACED to PAID" do
    product = Product.create :name => 'My Product', :price => 123
    @order.line_items.create :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.save!
    @order.status = 'PAID'
    @order.should be_valid
  end

  it "status can change from PLACED to CANCELLED, when this happens a short reason must be provided" do
    product = Product.create :name => 'My Product', :price => 123
    @order.line_items.create :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.save!
    @order.status = 'CANCELLED'
    @order.should be_invalid
    @order.status_update_reason = 'Some excuse'
    @order.should be_valid
    puts @order.errors
  end

  it "status cannot change in any other way. eg. status can never change back to DRAFT" do
    product = Product.create :name => 'My Product', :price => 123
    @order.line_items.create :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.save!
    @order.status = 'DRAFT'
    @order.should be_invalid
    @order.status = 'PAID'
    @order.save!
    @order.status = 'PLACED'
    @order.should be_invalid
    @order.status = 'DRAFT'
    @order.should be_invalid
  end

  it "Changes can be made to orders, including adding/editing/deleting line items, while the orders are DRAFTs" do
    product = Product.create! :name => 'My Product', :price => 123
    product2 = Product.create! :name => 'My Product2', :price => 11
    @order.line_items.create! :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.save!

    line_item = @order.line_items.new(:product_id => product2.id, :quantity => 123)
    line_item.should be_invalid
  end

  it "Changes should not be permitted once the status is either PLACED, PAID or CANCELLED, neither to the order itself nor its line items" do
    product = Product.create! :name => 'My Product', :price => 123
    @order.line_items.create! :product_id => product.id, :quantity => 12
    @order.status = 'PLACED'
    @order.save!
    @order.order_date = 3.days.from_now
    @order.should be_invalid
  end
end
