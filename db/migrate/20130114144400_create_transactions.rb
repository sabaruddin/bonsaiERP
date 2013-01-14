class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :account_id

      # Use Account#amount for total, create alias
      t.decimal :balance, :precision => 14, :scale => 2, default: 0.0 # Saldo

      # Use Account#name for ref_number create alias
      t.string  :bill_number # factura

      t.integer :project_id

      t.decimal :discount, :precision => 5,  :scale => 2, default: 0.0
      t.decimal :gross_total, :precision => 14, :scale => 2, default: 0.0
      t.decimal :original_total, :precision => 14, :scale => 2, default: 0.0
      t.decimal :balance_inventory, :precision => 14, :scale => 2, default: 0.0

      t.date    :payment_date
      # Creators approver
      t.integer  :creator_id
      t.integer  :approver_id
      t.integer  :nuller_id
      t.string   :null_reason, limit: 400
      t.datetime :approver_datetime
      t.string  :approver_reason

      t.boolean :delivered, default: false
      t.boolean :discounted, default: false
      t.boolean :devolution, default: false

      t.boolean :has_error, default: false
      t.string  :error_messages

      t.timestamps
    end

    add_index :transactions, :payment_date
    add_index :transactions, :has_error
    add_index :transactions, :delivered
    add_index :transactions, :discounted
    add_index :transactions, :devolution
    add_index :transactions, :bill_number

  end
end