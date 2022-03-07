class TourDetailsController < ApplicationController
  before_action :find_tour

  def update
    # case params[:type]
    @tour.update(tour_params)
    p params
    p 'params'
    render params[:type]
  end

  private

  def find_tour
    p params
    p 'params'
    @tour = Tour.find_by_id(params[:id])
  end

  def tour_params
    params.require(:tour).permit(:listing_address, :agent_email, :agent_name, :agent_url, :agent_phone, :first_image)
  end

end
