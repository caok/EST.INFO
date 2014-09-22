class EntriesController < ApplicationController
  def index
    @q = params[:q].present? ? Entry.unscoped.search(params[:q]) : Entry.unscoped.search
    @q.category_eq = params[:category] if params[:category].present?
    @entries = @q.result
    @history_prices = history_prices(@entries)
    @entries = @entries.order("created_at desc").page params[:page]
  end

  def show
    @entry = Entry.find(params[:id])
  end

  private
  def history_prices(entries)
    history_hash = {}
    history_prices = entries.where("created_at >= ?", 30.day.ago).group_by_day(:created_at, time_zone: "Beijing").order("day desc").average(:price)
    history_prices
  end
end
