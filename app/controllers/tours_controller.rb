class ToursController < ApplicationController
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4, :step5, :step6
  before_action :find_tour, only: [:show]

  def index
    random_array = [87416, 87417, 87418, 87419, 87420, 87421, 87422, 87423, 87424, 87425]
    @response = Tour.get_tour(random_array.shuffle.first)
    @tour = Tour.save_record(@response) if @response
    if @tour.present?
      render :index
    else
      render json: { errors: @tour.errors }, status: :unprocessable_entity
    end
  end

  def show
    case step
    when :step2
      @images = @tour.images
    end
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
