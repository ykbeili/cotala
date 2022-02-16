class Tour < ApplicationRecord
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http
  has_many :images, dependent: :destroy
  # get tour info from cotala
  def self.get_tour(tour_id)
    begin
      @response = Faraday.get("https://www.cotala.com/printjobs/#{tour_id}/data.txt")
      @parsed_response_hash = parse_response(@response.body)
      @parsed_response_hash
    rescue StandardError
      p StandardError
    end
  end

  def self.save_record(response)
    @tour = Tour.new
    @tour.agent_name = response["AgentName"]
    # @tour.agent_phone = response["AgentPhone"]
    # @tour.agent_email = response["AgentEmail"]
    # @tour.agent_url = response["AgentUrl"]
    # @tour.brokerage_name = response["BrokerageName"]
    # @tour.brokerage_address = response["BrokerageAddress"]
    # @tour.brokerage_brand = response["BrokerageBrand"]
    # @tour.broker_logo = response["BrokerLogo"]
    # @tour.listing_address = response["ListingAddress"]
    # @tour.show_price = response["ShowPrice"]
    # @tour.price = response["Price"]
    # @tour.mls = response["MLS"]
    # @tour.tax = response["Tax"]
    # @tour.built = response["Built"]
    # @tour.no_of_bedrooms = response["Bedrooms"]
    # @tour.no_of_barhrooms = response["Bathrooms"]
    # @tour.size = response["Size"]
    # @tour.lot_or_maint = response["Lot_or_Maint"]
    # @tour.lot_maint = response["LotMaint"]
    # @tour.description = response["Description"]
    # @tour.style = response["Style"]
    # @tour.type = response["Type"]
    # @tour.tour_id = response["TourID"]
    # @tour.num_of_pics = response["NumPics"]
    # @tour.print_job_id = response["PrintjobID"]
    if @tour.save
      @tour
    else
      'error'
    end
  end

  private
  # parse api response
  def self.parse_response(response)
    parsed_response_hash = {}
    parsed_response = response.split("\t")
    hash_keys = get_response_array(parsed_response)[:hash_keys]
    hash_values = get_response_array(parsed_response)[:hash_values]
    hash_keys.each_with_index do |key, index|
      parsed_response_hash[key] = hash_values[index]
    end
    images = get_images(hash_keys, hash_values)
    parsed_response_hash
  end
  # 
  def self.get_response_array(response)
    hash_keys = []
    hash_values = []
    response.each_with_index do |e, index|
      if index < response.count / 2
        hash_keys.push(e)
      else
        hash_values.push(e)
      end
    end
    { hash_keys: hash_keys, hash_values: hash_values }
  end

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

  def self.get_images(keys, values)
    images = []
    keys.each_with_index do |key, index|
      images.push(values[index]) if key.include?('@mlsPick')
    end
    images
  end
end
