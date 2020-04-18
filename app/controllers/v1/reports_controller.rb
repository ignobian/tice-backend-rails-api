class V1::ReportsController < ApplicationController
  before_action :auth_required

  def index
    @reports = Report.all
  end

  def create
    @report = Report.new(report_params)
    @blog = Blog.find(params[:blog_id])
    @report.user = @user
    @report.blog = @blog
    if !@report.save
      return render json: { error: @report.errors.full_messages.first }
    end
  end

  private

  def report_params
    params.require(:report).permit(:name)
  end
end
