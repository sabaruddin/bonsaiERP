# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class Item < ActiveRecord::Base

  ##########################################
  # Callbacks
  before_save :trim_code
  before_save :set_unit
  before_destroy :check_items_destroy

  ##########################################
  # Relationships
  belongs_to :unit
  has_many   :stocks
  has_many   :income_details
  has_many   :expense_details
  has_many   :inventory_details

  ##########################################
  # Validations
  validates_presence_of   :name, :unit, :unit_id
  validates_uniqueness_of :code , if: "code.present?"
  validates_uniqueness_of :name

  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :buy_price, numericality: { greater_than_or_equal_to: 0 }


  ##########################################
  # Scopes
  scope :active   , -> { where(active: true) }
  scope :income   , -> { where(active: true, for_sale: true) }
  scope :inventory, -> { where(stockable: true) }
  scope :search   , ->(s) {
    s = "%#{s}%"
    where{(name.like "#{s}") | (code.like "#{s}")}
  }

  def to_s
    name
  end

  # Sums the stocks of a item
  def total_stock
    stocks.reduce(0) {|sum, st| sum += st.quantity }
  end

private
  # checks if there are any items on destruction
  def check_items_destroy
    if TransactionDetail.where(item_id: id).any? or InventoryDetail.where(item_id: id).any?
      errors.add(:base, "El item es usado en otros registros relacionados")
      false
    else
      true
    end
  end

  def trim_code
    self.code = code.to_s.strip
  end

  def set_unit
    self.unit_symbol = unit.symbol
    self.unit_name = unit.name
  end
end
