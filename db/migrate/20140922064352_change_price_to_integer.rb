class ChangePriceToInteger < ActiveRecord::Migration
  def up
    Entry.all.each do |e|
      price = e.price.to_s.match(/\d{1,}/).to_s.to_i
      e.update(price: price) if e.price.to_i != price or e.price.blank?
    end

    change_column :entries, :price, 'integer USING CAST(price AS integer)'
  end
end
