class ToursController < ApplicationController
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4, :step5, :step6

  def index
    # conn = Faraday.new do |f|
    #   f.request :json # encode req bodies as JSON
    #   # f.request :retry # retry transient failures
    #   f.response :json # decode response bodies as JSON
    #   f.adapter :net_http # Use the Net::HTTP adapter
    # end
    # @response = conn.get('https://www.cotala.com/printjobs/86588/data.txt')
    # https://www.cotala.com/printjobs/86588/data.txt
    # https://www.cotala.com/printjobs/86697/data.txt
    # https://www.cotala.com/printjobs/86688/data.txt
    random_array = [86_588, 86_697, 86_688]
    @response = Faraday.get("https://www.cotala.com/printjobs/#{random_array.sample}/data.txt")
    @header_elements = []
    @body_elemets = []
    array = @response.body.split("\t")
    array.each_with_index do |e, index|
      if index < array.count / 2
        @header_elements.push(e)
      else
        @body_elemets.push(e)
      end
    end
    @tour_id = get_tour_id(@header_elements)
    @images = get_images(@header_elements, @body_elemets)
    [@header_elements, @body_elemets, @tour_id, @images]
  end

  def show
    case step
    when :step2
      @images = 
    end
    render_wizard
  end

  def download_ofs
    send_file("#{Rails.root}/public/OFS.pdf")
  end

  private

  def get_tour_id(elements)
    tour_id = ''
    elements.each_with_index do |element, index|
      if element.include?('TourID')
        tour_id = @body_elemets[index]
        next
      end
    end
    tour_id
  end

  def get_images(elements, body_elements)
    images = []
    elements.each_with_index do |element, index|
      images.push(body_elements[index]) if element.include?('@mlsPick')
    end
    images
  end
end
