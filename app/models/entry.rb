class Entry < ActiveRecord::Base
  scope :today, -> { where(happend_at: Time.new.beginning_of_day()..Time.new.end_of_day()) }
  scope :dgtle, -> { where(source: 'dgtle') }
  scope :fengniao, -> { where(source: 'fengniao') }
  scope :macx, -> { where(source: 'macx') }
  scope :v2ex, -> { where(source: 'v2ex') }

  def self.summary
    array = []
    array << {source: 'dgtle', num: Entry.today.dgtle.count }
    array << {source: 'fengniao', num: Entry.today.fengniao.count }
    array << {source: 'macx', num: Entry.today.macx.count }
    array << {source: 'v2ex', num: Entry.today.v2ex.count }

    return array
  end
end
