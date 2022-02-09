class ToursController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4, :step5, :step6
  before_action :find_tour, only: [:show]

  def index
    random_array = [86_588, 86_697, 86_688, 87416, 87417, 87418, 87419, 87420, 87421, 87422, 87423, 87424, 87425]
    @response = Tour.get_tour(87423)
    @tour = Tour.save_record(@response)
    if @tour !== 'error'
      render :index
    else
      render json: { errors: @tour.errors }, status: :unprocessable_entity
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
