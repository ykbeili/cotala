class ToursController < ApplicationController
  include Wicked::Wizard
  require "prawn"
  steps :step1, :step2, :step3, :step4, :step5, :step6
  before_action :find_tour, only: [:show, :update]

  def index
    random_array = [87416, 87417, 87418, 87419, 87420, 87424, 87425, 87427]
    @response = Tour.get_tour(random_array.shuffle.first)
    @tour = Tour.save_record(@response) if @response
    if @tour.present?
      render :index
    else
      render json: { errors: @tour.errors }, status: :unprocessable_entity
    end
  end

  def show
    # end
    render_wizard
  end

  def download_ofs
    send_file("#{Rails.root}/public/OFS.pdf")
  end

  def create_pdf
    @tour = Tour.find_by_id(params[:tour_id])
    pdf = TourDocument.new(@tour)
    send_data pdf.render,
    filename: "#{@tour.agent_name}-#{@tour.cotala_tour_id}.pdf"
  end

  def update
    case step
    when :step2
      tp = tour_params
      tp["selected_images"] = tp["selected_images"].split(',')
      @tour.update(tp)
    when :step3
      tp = tour_params
      p tp
      p 'tp'
      @tour.update(tp)
    end
    render_wizard
  end

  private

  def find_tour
    @tour = Tour.find_by_id(params[:tour_id])
  end

  def tour_params
    params.require(:tour).permit(:selected_images, :selected_theme, :listing_address, :agent_email, :agent_name, :agent_url, :agent_phone)
  end
end
