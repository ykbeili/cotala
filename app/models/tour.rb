class Tour < ApplicationRecord
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http
  has_many :images, dependent: :destroy

  # get tour info from cotala
  def self.get_tour(print_job_id)
    begin
      @response = Faraday.get("https://www.cotala.com/printjobs/#{print_job_id}/data.txt")
      @parsed_response_hash = parse_response(@response.body)
      @parsed_response_hash
    rescue StandardError
      p StandardError
    end
  end

  def self.save_record(response)
    images = get_images(response["NumPics"])
    @tour = Tour.new
    tour_images = []
    images.each do |image|
      tour_image = Image.create(name: image)
      tour_images.push(tour_image)
    end
    @tour.images = tour_images
    @tour.agent_name = response["AgentName"]
    @tour.agent_phone = response["AgentPhone"]
    @tour.agent_email = response["AgentEmail"]
    @tour.agent_url = response["AgentUrl"]
    @tour.brokerage_name = response["BrokerageName"]
    @tour.brokerage_address = response["BrokerageAddress"]
    @tour.brokerage_brand = response["BrokerageBrand"]
    @tour.broker_logo = response["BrokerLogo"]
    @tour.listing_address = response["ListingAddress"]
    @tour.show_price = response["ShowPrice"]
    @tour.price = response["Price"]
    @tour.mls = response["MLS"]
    @tour.tax = response["Tax"]
    @tour.built = response["Built"]
    @tour.bedrooms = response["Bedrooms"]
    @tour.bathrooms = response["Bathrooms"]
    @tour.size = response["Size"]
    @tour.lot_or_maint = response["Lot_or_Maint"] == "Lot" ? true : false
    @tour.lot_maint = response["LotMaint"]
    @tour.description = response["Description"]
    @tour.style = response["Style"]
    @tour.property_type = response["Type"]
    @tour.cotala_tour_id = response["TourID"]
    @tour.num_of_pics = response["NumPics"]
    @tour.print_job_id = response["PrintjobID"]
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
    parsed_respons_hash = get_response_arrays(parsed_response)
    hash_keys = parsed_respons_hash[:hash_keys]
    hash_values = parsed_respons_hash[:hash_values]
    hash_keys.each_with_index do |key, index|
      parsed_response_hash[key] = hash_values[index]
    end
    parsed_response_hash
  end

  def self.get_response_arrays(response)
    hash_keys = []
    hash_values = []
    response.each_with_index do |e, index|
      if e.include?("\"")
        e = e.gsub!('"', '')
      end
      if e.include?("\n")
        e = e.chomp("\n")
      end
      if e.include?('PrintjobID') 
        print_job_id = e.slice(0..9)
        agent_name = e.slice(12..e.length - 2)
        hash_keys.push(print_job_id)
        hash_values.push(agent_name)
        next
      end
      if index < response.count / 2
        hash_keys.push(e)
      else
        hash_values.push(e)
      end
    end
    { hash_keys: hash_keys, hash_values: hash_values }
  end

  def self.get_images(num_of_pics)
    images = []
    num_of_pics = num_of_pics.to_i
    (1..num_of_pics).each do |key|
      images.push(key.to_s + '.jpg')
    end
    images
  end
end
