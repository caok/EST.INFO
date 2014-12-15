class HomeController < ApplicationController
  def disqus 
    render layout: "disqus"
  end

  def clean_delayed_jobs
    DelayedJob.delete_all
    redirect_to admin_delayed_jobs_path, notice: "Delete delayed jobs successful."
  end
end
