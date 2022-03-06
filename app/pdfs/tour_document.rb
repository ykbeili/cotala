class TourDocument < Prawn::Document
  require "open-uri"
  require './lib/extract_images'

  PDF_SIZE = [1632, 1056]

  def initialize(tour)
    super(:page_size => PDF_SIZE)
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
    rotate(270, origin: [460, 400]) do 
      add_content(image)
    end
    add_crop_marks()
    fill_color '6c6d70'
    font_size 14
    text_box "Listing Features", :at => [880, 900], style: "normal"
    font_size 20
    text_box "#{@tour.listing_address}", :at => [880, 875], style: "bold"
    image open(borker_log), fit: [100, 100], :at => [1450, 925]
    image open(main_image), :width => 700, :height => 575, :at => [830, 800]
    image open(broker_image), fit: [200, 200], :at => [880, 200]
    text_box "#{@tour.agent_name}", :at => [1125, 200]
    font_size 8
    text_box "Personal Real Estate Corportation", :at => [1125, 175]
    font_size 20
    text_box "#{@tour.agent_phone}", :at => [1125, 160]
    font_size 8
    text_box "#{@tour.agent_email}", :at => [1125, 135]
    text_box "#{@tour.agent_url}", :at => [1125, 120]
    image open(borker_log), fit: [100, 100], :at => [1450, 185]
  end

  def second_page
    add_crop_marks()
    fill_color '6c6d70'
    font_size 20
    text_box "#{@tour.listing_address}", :at => [40, 960]
    text_box "Listed for: $#{@tour.price}", :at => [40, 900], style: "bolder"
    font_size 8
    tour_description = @tour.description
    font_size 12
    text_box "#{tour_description}", :at => [40, 850], :width => 600, :leading => 5
    font_size 16
    text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}", :at => [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    image open(main_image), :width => 700, :height => 400, :at => [40, 600]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[2].name}"), :width => 225, :height => 150, :at => [40, 185]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[3].name}"), :width => 225, :height => 150, :at => [275, 185]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[4].name}"), :width => 225, :height => 150, :at => [510, 185]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[5].name}"), :width => 700, :height => 450, :at => [830, 960]
  
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[6].name}"), :width => 225, :height => 150, :at => [830, 500]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[7].name}"), :width => 225, :height => 150, :at => [1090, 500]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[8].name}"), :width => 225, :height => 150, :at => [1350, 500]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[9].name}"), :width => 225, :height => 150, :at => [830, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[10].name}"), :width => 225, :height => 150, :at => [1090, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[11].name}"), :width => 225, :height => 150, :at => [1350, 340]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[12].name}"), :width => 225, :height => 150, :at => [830, 180]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[13].name}"), :width => 225, :height => 150, :at => [1090, 180]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[14].name}"), :width => 225, :height => 150, :at => [1350, 180]
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
