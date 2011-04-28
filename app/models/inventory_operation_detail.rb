# encoding: utf-8
# author: Boris Barroso
# email: boriscyber@gmail.com
class InventoryOperationDetail < ActiveRecord::Base
  acts_as_org

  attr_reader :transaction

  belongs_to :inventory_operation
  belongs_to :item

  validates_presence_of :item_id, :quantity
  validates_numericality_of :quantity, :greater_than => 0, :unless => :transaction?
  validates_numericality_of :quantity, :greater_than_or_equal_to => 0, :if => :transaction?
  #validate :valid_quantity_for_transaction

  # Setter for @transaction
  def set_transaction=(val)
    @transaction = val
  end

  def transaction?
    @transaction || false
  end

private


  # Validtes the quantiry for a transaction
  def valid_quantity_for_transaction
    #if inventory_operation.transaction_id.present?
    #  it = inventory_operation.transaction.transaction_details.find_by_item_id(item_id)

    #  if quantity > it.balance
    #    det.errors.add(:quantity, "Cantidad mayor a la permitida")
    #  end
    #end
  end
end