class LineItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity
  validates_presence_of :order_id, :product_id, :quantity
  validates_numericality_of :quantity, :only_integer => false, :greater_than => 0

  validate :order_should_be_draft

  belongs_to :product
  belongs_to :order

  before_destroy :order_should_be_draft

  def order_should_be_draft
    if order
      if order.status == 'DRAFT'
        true
      else
        errors.add(:order_id, :message => 'Order is no longer a draft')
        false
      end
    else
      true
    end
  end

  def delete
    if order.status == 'DRAFT'
      super
    else
      false
    end
  end
end
