class Order < ActiveRecord::Base
  attr_accessor :status_update_reason
  attr_accessible :order_date, :status
  validates_inclusion_of :status, :in => %w( DRAFT PLACED PAID CANCELLED )
  validate :status_update_valid?
  validate :order_date_valid?

  validate :updation_allowed?

  before_destroy :not_allowed

  has_many :line_items
  has_many :products, :through => :line_items

  def updation_allowed?
    unless status == 'DRAFT' or status_was == 'DRAFT'
      changed_attribs = changed_attributes.clone
      changed_attribs.delete('status')
      errors.add(:status, :message => 'No changes allowed after the order is not draft') unless changed_attribs.empty?
    end
  end

  def not_allowed
    false
  end

  def order_date_valid?
    if order_date_changed? or !persisted?
      errors.add(:order_date, 'Order date cant be in past') if order_date.past?
    end
  end

  def status_update_valid?
    validity = false
    if status_changed?
      if status_was == 'DRAFT' and status == 'PLACED'
        validity = true if line_items.count > 0
      end
      if (status_was == 'DRAFT' or status_was == 'PLACED') and status == 'CANCELLED'
        validity = true if status_update_reason.present?
      end
      if status_was == 'PLACED' and status == 'PAID'
        validity = true
      end
    else
      validity = true
    end
    errors.add(:status, :message => 'Status change invalid') unless validity
  end

  def delete
    false
  end

  def self.delete_all
    false
  end

  def net_total
    line_items.collect { |item| item.product.price * item.quantity }.inject(:+)
  end

  def gross_total
    net = net_total
    net + VAT_PERCENT * net
  end
end
