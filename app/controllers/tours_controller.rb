class ToursController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4, :step5, :step6
  before_action :find_tour, only: [:show]

  def index
    random_array = [86_588, 86_697, 86_688]
    @response = Tour.get_tour(random_array.sample)
    if @response
      @tour = Tour.new
      @tour.agent_name = @response["AgentName"]
      if @tour.save
        render :index
      else
        render json: { errors: @tour.errors }, status: :unprocessable_entity
      end
    end
  end

  def show
    render_wizard
  end

  def download_ofs
    send_file("#{Rails.root}/public/OFS.pdf")
  end

  private

  def find_tour
    @tour = Tour.find_by_id(params[:tour_id])
  end
end
