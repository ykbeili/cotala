class ToursController < ApplicationController
  include Wicked::Wizard
  require 'net/ftp'
  require 'prawn'
  steps :step1, :step2, :step3, :step4, :step5
  include ActionView::Helpers::NumberHelper
  before_action :find_tour, only: %i[show update]
  FTP_LINK = 'ftp.cotala.com'.freeze
  before_action :get_cotala_tour_id, only: %i[step1]

  def step1
    random_array = [87_416, 87_417, 87_418, 87_419, 87_420, 87_424, 87_425, 87_427]
    if @cotala_tour_id 
      @response = Tour.get_tour(@cotala_tour_id)
    else
      @response = Tour.get_tour(90157)
    end
    @tour = Tour.save_record(@response)
    if @tour.present?
      render :step1
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

  def create_pdf
    a = Time.new()
    @tour = Tour.find_by_id(params[:tour_id])
    TourDocumentJob.perform_later(@tour.id)
    # @pdf = TourDocument.new(@tour)
    # send_data @pdf.render,
    #           filename: "#{@tour.agent_name}-#{@tour.cotala_tour_id}.pdf",
    #           :disposition => 'inline',
    #           :type => "application/pdf"
    
    # ftp = Net::FTP.new(FTP_LINK)
    # ftp.login('tam@cotala.com', 'B*22?Rpdlen+')
    # file_path = "#{Rails.root}/tmp/#{@tour.agent_name}-#{@tour.cotala_tour_id}.pdf"
    # pdf.render_file file_path
    # version = @tour.version || 2
    # ftp.putbinaryfile(file_path, "#{@tour.print_job_id}/#{@tour.print_job_id}-#{version}-b.pdf")
    redirect_to @tour.hook_url if @tour.hook_url.present?
  end

  def create_preview_pdf
    a = Time.new()
    @tour = Tour.find_by_id(params[:tour_id])
    pdf = TmpTourDocument.new(@tour)
    send_data pdf.render,
              filename: "#{@tour.agent_name}-#{@tour.cotala_tour_id}.pdf",
              :type => "application/pdf",
              :disposition => 'inline'
  end

  def update
    case step
    # when :step2
    #   tp = tour_params
    #   tp['selected_images'] = tp['selected_images'].split(',')
    #   @tour.first_image = tp['selected_images'][0]
    #   @tour.second_image = tp['selected_images'][1]
    #   @tour.third_image = tp['selected_images'][2]
    #   @tour.fourth_image = tp['selected_images'][3]
    #   @tour.fifth_image = tp['selected_images'][4]
    #   @tour.sixth_image = tp['selected_images'][5]
    #   @tour.seventh_image = tp['selected_images'][6]
    #   @tour.eighth_image = tp['selected_images'][7]
    #   @tour.ninth_image = tp['selected_images'][8]
    #   @tour.tenth_image = tp['selected_images'][9]
    #   @tour.eleventh_image = tp['selected_images'][10]
    #   @tour.twelfth_image = tp['selected_images'][11]
    #   @tour.thirteenth_image = tp['selected_images'][12]
    #   @tour.fourteenth_image = tp['selected_images'][13]
    #   @tour.fifteenth_image = tp['selected_images'][14]
    #   @tour.update(tp)
    when :step2
    when :step3
      tp = tour_params
      @tour.update(tp)
    when :step4
      tp = tour_params
      @tour.update(tp)
    end
    render_wizard
  end

  private

  def find_tour
    @tour = Tour.find_by_id(params[:tour_id])
  end

  def get_cotala_tour_id
    @cotala_tour_id = params.require(:print_job_id) if params[:print_job_id].present?
  end

  def tour_params
    params.require(:tour).permit(:selected_images, :selected_theme, :listing_address, :agent_email, :agent_name,
                                 :agent_url, :agent_phone, :price, :bathrooms, :bedrooms, :lot_maint, :description, :size,
                                 :tax, :first_image)
  end
end
