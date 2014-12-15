ActiveAdmin.register DelayedJob do
  menu :priority => 12
  actions :all, except: [:new, :create, :edit, :update]
  config.sort_order = "id_desc"

  action_item :only => :index do
    link_to "Clear all delayed jobs", clean_delayed_jobs_path
  end

  index do
    selectable_column
    column :priority
    column :attempts
    column :handler
    column :last_error
    column :queue
    column :run_at
    column :created_at
    actions
  end
end
