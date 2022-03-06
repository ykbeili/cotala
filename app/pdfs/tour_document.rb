class TourDocument < Prawn::Document
  require "open-uri"
  require './lib/extract_images'

  def initialize(tour)
    super(:page_size => [1632, 1056])
    @tour = tour
    first_page
    start_new_page
    second_page
  end

  def first_page
    floor_plan = "https://images.squarespace-cdn.com/content/v1/5bdde6530dbda3230ba6bd5d/1542039146291-IY4AG1D0JN2D1400BZ1C/Matterport+-+Best+Practices+for+Schematic+Floor+Plans.jpg?format=1000w"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    image = get_image_from_pdf()
    rotate(270, origin: [420, 400]) do 
      add_content(image)
    end
    add_crop_marks()
    fill_color '6c6d70'
    font_size 14
    text_box "Listing Features", :at => [880, 900], style: "normal"
    font_size 20
    text_box "#{@tour.listing_address}", :at => [880, 875], style: "bold"
    image open(borker_log), fit: [100, 100], :at => [1450, 900]
    image open(main_image), fit: [700, 1000], :at => [850, 800]
    image open(broker_image), fit: [200, 200], :at => [880, 250]
    text_box "#{@tour.agent_name}", :at => [1125, 250]
    font_size 8
    text_box "Personal Real Estate Corportation", :at => [1125, 225]
    font_size 20
    text_box "#{@tour.agent_phone}", :at => [1125, 210]
    font_size 8
    text_box "#{@tour.agent_email}", :at => [1125, 185]
    text_box "#{@tour.agent_url}", :at => [1125, 170]
    image open(borker_log), fit: [100, 100], :at => [1450, 185]
  end

  def second_page
    stroke_axis
    add_crop_marks()
    fill_color '6c6d70'
    font_size 20
    text_box "#{@tour.listing_address}", :at => [0, 960]
    text_box "Listed for: $#{@tour.price}", :at => [0, 900], style: "bolder"
    font_size 8
    tour_description = @tour.description
    font_size 12
    text_box "#{tour_description}", :at => [0, 850], :width => 600, :leading => 5
    font_size 16
    text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}", :at => [0, 750]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    image open(main_image), fit: [800, 350], :at => [0, 700]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[2].name}"), :width => 170, :height => 110, :at => [0, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[3].name}"), :width => 170, :height => 110, :at => [175, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[4].name}"), :width => 170, :height => 110, :at => [355, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[5].name}"), :width => 700, :height => 400, :at => [850, 960]
  
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[6].name}"), :width => 200, :height => 150, :at => [850, 540]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[7].name}"), :width => 200, :height => 150, :at => [1110, 540]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[8].name}"), :width => 200, :height => 150, :at => [1370, 540]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[9].name}"), :width => 200, :height => 150, :at => [850, 380]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[10].name}"), :width => 200, :height => 150, :at => [1110, 380]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[11].name}"), :width => 200, :height => 150, :at => [1370, 380]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[12].name}"), :width => 200, :height => 150, :at => [850, 220]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[13].name}"), :width => 200, :height => 150, :at => [1110, 220]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[14].name}"), :width => 200, :height => 150, :at => [1370, 220]
  end

  def add_crop_marks
    # top left
    stroke_line [-40, 980], [-10,980] # left 
    stroke_line [0, 1150], [0, 990] # right
    # bottom left
    stroke_line [-40, 0], [-10, 0] # left
    stroke_line [0, -40], [0, -10] # right
    # top right
    stroke_line [1560, 1060], [1560, 1000] # left
    stroke_line [1600, 990], [1570, 990] # right
    # bottom right
    stroke_line [1560, -40], [1560, -10] # left
    stroke_line [1600, 0], [1570, 0] # right
  end

  def get_image_from_pdf
    io     = open('http://www.cotala.com/tours/60829/Floorplan.pdf')
    reader = PDF::Reader.new(io)
    page = reader.page(1)
    return page.raw_content
  end
end
