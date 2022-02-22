class TourDocument < Prawn::Document
  require "open-uri"
  def initialize(tour)
    super(:page_size => [1632, 1056])
    @tour = tour
    first_page
    start_new_page
    second_page
  end
  
  def first_page
    # stroke_axis
    floor_plan = "https://images.squarespace-cdn.com/content/v1/5bdde6530dbda3230ba6bd5d/1542039146291-IY4AG1D0JN2D1400BZ1C/Matterport+-+Best+Practices+for+Schematic+Floor+Plans.jpg?format=1000w"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    # line_width(5) :at => [-40, 1000]
    # line [50, 1000], [150, 1200]
    stroke_line [-40, 980], [-10,980]
    stroke_line [0, 1050], [0, 990]

    stroke_line [-40, 10], [0,10]
    stroke_line [10, -40], [10, 0]

    stroke_line [1540, 1050], [1540, 975]
    stroke_line [1600, 975], [1560, 975]

    stroke_line [1540, -40], [1540, 0]
    stroke_line [1600, 20], [1560, 20]

    image open(floor_plan), fit: [750, 800], :at => [0, 1000]
    fill_color '6c6d70'
    font_size 16
    text_box "Listing Features", :at => [900, 900], style: "normal"
    font_size 20
    text_box "#{@tour.listing_address}", :at => [900, 875]
    image open(borker_log), fit: [100, 100], :at => [1400, 950]
    image open(main_image), fit: [600, 800], :at => [850, 800]
    image open(broker_image), fit: [200, 200], :at => [900, 350]
    text_box "#{@tour.agent_name}", :at => [1125, 350]
    font_size 8
    text_box "Personal Real Estate Corportation", :at => [1125, 325]
    font_size 20
    text_box "#{@tour.agent_phone}", :at => [1125, 300]
    font_size 8
    text_box "#{@tour.agent_email}", :at => [1125, 270]
    text_box "#{@tour.agent_url}", :at => [1125, 250]
    image open(borker_log), fit: [100, 100], :at => [1375, 325]
  end

  def second_page
    stroke_line [-40, 980], [0,980]
    stroke_line [0, 1050], [0, 990]

    stroke_line [-40, 10], [0,10]
    stroke_line [10, -40], [10, 0]

    stroke_line [1540, 1050], [1540, 975]
    stroke_line [1600, 975], [1560, 975]

    stroke_line [1540, -40], [1540, 0]
    stroke_line [1600, 20], [1560, 20]
    fill_color '6c6d70'
    font_size 20
    text_box "#{@tour.listing_address}", :at => [40, 900]
    text_box "Listed for: $#{@tour.price}", :at => [40, 825], style: "bold"
    font_size 8
    tour_description = @tour.description
    text_box "#{tour_description}", :at => [40, 750], :width => 400
    font_size 16
    text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}", :at => [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    image open(main_image), fit: [800, 300], :at => [30, 550]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[2].name}"), :width => 140, :height => 75, :at => [30, 240]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[3].name}"), :width => 140, :height => 75, :at => [185, 240]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[4].name}"), :width => 140, :height => 75, :at => [340, 240]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[5].name}"), fit: [800, 300], :at => [850, 900]
  
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[6].name}"), :width => 140, :height => 75, :at => [850, 575]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[7].name}"), :width => 140, :height => 75, :at => [1000, 575]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[8].name}"), :width => 140, :height => 75, :at => [1150, 575]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[9].name}"), :width => 140, :height => 75, :at => [850, 475]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[10].name}"), :width => 140, :height => 75, :at => [1000, 475]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[11].name}"), :width => 140, :height => 75, :at => [1150, 475]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[12].name}"), :width => 140, :height => 75, :at => [850, 375]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[13].name}"), :width => 140, :height => 75, :at => [1000, 375]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[14].name}"), :width => 140, :height => 75, :at => [1150, 375]
    # image open(main_image), :width => 190, :height => 100, :at => [650, 890]
    # image open(main_image), :width => 190, :height => 100, :at => [850, 890]
    # image open(main_image), :width => 190, :height => 100, :at => [1050, 890]
    # image open(main_image), :width => 190, :height => 100, :at => [650, 790]
    # image open(main_image), :width => 190, :height => 100, :at => [850, 790]
    # image open(main_image), :width => 190, :height => 100, :at => [1050, 790]
    # image open(main_image), :width => 190, :height => 100, :at => [650, 690]
    # image open(main_image), :width => 190, :height => 100, :at => [850, 690]
    # image open(main_image), :width => 190, :height => 100, :at => [1050, 690]
  end
end
