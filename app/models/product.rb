class Product < ActiveRecord::Base
  attr_accessible :name, :price
  validates_uniqueness_of :name
  validates_numericality_of :price, :only_integer => false, :greater_than => 0
  validates_presence_of :name, :price

  has_many :line_items
  has_many :orders, :through => :line_items

  before_destroy :destruction_valid?

  def destruction_valid?
    if orders.empty?
      true
    else
      false
    end
  end
end
