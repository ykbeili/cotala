class TourDocument < Prawn::Document
  require 'open-uri'
  require 'rqrcode'
  PDF_SIZE = [1632, 1056].freeze

  def initialize(tour)
    super(page_size: PDF_SIZE)
    @tour = tour
    first_page
    start_new_page
    second_page
  end

  def first_page
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    floor_plan = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/Floorplan_Branded.jpg"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    agent_headshot_url = @tour.agent_headshot_url
    image open(floor_plan), fit: [700, 900], at: [40, 950]
    add_crop_marks
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 14
    text_box 'Listing Features', at: [880, 900], style: 'normal'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [880, 875], style: 'bold'
    image open(borker_log), fit: [100, 100], at: [1450, 925]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.first_image}"),
          width: 700, height: 575, at: [830, 800]
    image open(broker_image), fit: [200, 200], at: [880, 200]
    stroke_line [1110, 205], [1110, 105]
    text_box @tour.agent_name.to_s, at: [1125, 200]
    font_size 8
    fill_color 'b0b0b0'
    text_box 'Personal Real Estate Corportation', at: [1125, 175]
    font_size 18
    fill_color '6c6d70'
    text_box @tour.agent_phone.to_s, at: [1125, 160], style: 'normal'
    font_size 8
    fill_color 'b0b0b0'
    text_box @tour.agent_email.to_s, at: [1125, 135]
    text_box @tour.agent_url.to_s, at: [1125, 120]
    #     image open(agent_headshot_url), fit: [100, 100], at: [1450, 185] if agent_headshot_url.present?
    image open(borker_log), fit: [100, 100], at: [1450, 185]
  end

  def second_page
    qrcode = RQRCode::QRCode.new('http://github.com/')
    qrcode_to_png = qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: 'black',
      file: nil,
      fill: 'white',
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 120
    )
    qrcode_image = IO.binwrite('/tmp/github-qrcode.png', qrcode_to_png.to_s)
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    add_crop_marks
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [40, 960]
    font_size 6
    text_box 'LISTED', at: [40, 900], style: 'normal'
    text_box 'FOR', at: [40, 890]
    font_size 24
    text_box "$#{@tour.price}", at: [65, 900], style: 'bolder'
    font_size 8
    tour_description = @tour.description
    font_size 14
    fill_color 'c1c1c1'
    text_box tour_description.to_s, at: [40, 830], width: 700, leading: 7, style: 'normal'
    font_size 14
    fill_color 'b0b0b0'
    text_box '__________________________________________________________________________________________',
             at: [40, 650]
    text_box '__________________________________________________________________________________________',
             at: [40, 620]
    text_box 'LOT', at: [40, 629]
    text_box "#{@tour.lot_maint} SF", at: [90, 629]
    text_box '|', at: [170, 629]
    text_box 'SIZE', at: [200, 629]
    text_box "#{@tour.lot_maint} SF", at: [250, 629]
    text_box '|', at: [320, 629]
    text_box @tour.bedrooms.to_s, at: [360, 629]
    text_box 'BED', at: [375, 629]
    text_box '|', at: [430, 629]
    text_box @tour.bathrooms.to_s, at: [470, 629]
    text_box 'BATH', at: [485, 629]
    text_box '|', at: [550, 629]
    text_box 'TAXES', at: [570, 629]
    text_box @tour.tax.to_s, at: [650, 629]
    #     text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}",
    #              at: [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.second_image}"
    image open(main_image), width: 700, height: 400, at: [40, 600]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.third_image}"),
          width: 230, height: 150, at: [40, 195]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourth_image}"),
          width: 230, height: 150, at: [275, 195]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifth_image}"),
          width: 230, height: 150, at: [510, 195]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.sixth_image}"),
          width: 700, height: 450, at: [830, 960]
    image open('/tmp/github-qrcode.png'), at: [1410, 960]

    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.seventh_image}"),
          width: 230, height: 150, at: [830, 505]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eighth_image}"),
          width: 230, height: 150, at: [1065, 505]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.ninth_image}"),
          width: 230, height: 150, at: [1300, 505]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.tenth_image}"),
          width: 230, height: 150, at: [830, 350]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eleventh_image}"),
          width: 230, height: 150, at: [1065, 350]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.twelfth_image}"),
          width: 230, height: 150, at: [1300, 350]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.thirteenth_image}"),
          width: 230, height: 150, at: [830, 195]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourteenth_image}"),
          width: 230, height: 150, at: [1065, 195]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifteenth_image}"),
          width: 230, height: 150, at: [1300, 195]
  end

  def add_crop_marks
    # top left
    stroke_line [-40, 980], [-10, 980] # left
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
end
