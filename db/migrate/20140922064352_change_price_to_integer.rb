class ChangePriceToInteger < ActiveRecord::Migration
  def up
    change_column :entries, :price, 'integer USING CAST(price AS integer)'
  end
end
