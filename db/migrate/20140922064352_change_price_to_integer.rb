class ChangePriceToInteger < ActiveRecord::Migration
  def up
    Entry.all.each do |e|
      e.price = e.price.to_s.match(/\d{1,}/).to_s
      e.save!
    end

    change_column :entries, :price, 'integer USING CAST(price AS integer)'
  end
end
