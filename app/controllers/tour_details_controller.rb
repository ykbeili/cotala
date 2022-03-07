class TourDetailsController < ApplicationController
  before_action :find_tour

  def update
    # case params[:type]
    @tour.update(tour_params)
    render params[:type]
  end

  private

  def find_tour
    @tour = Tour.find_by_id(params[:id])
  end

  def tour_params
    params.require(:tour).permit(:listing_address, :agent_email, :agent_name, :agent_url, :agent_phone, :first_image, :second_image, :third_image, :fourth_image, :fifth_image, :sixth_image, :seventh_image, :eighth_image, :ninth_image, :tenth_image, :eleventh_image, :twelfth_image, :thirteenth_image, :fourteenth_image, :fifteenth_image, :size, :lot_maint, :bathrooms, :bedrooms, :price, :tax, :description)
  end

end

