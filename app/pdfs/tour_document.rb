class TourDocument < Prawn::Document
  require 'open-uri'
  require 'rqrcode'
  PDF_SIZE = [1300, 870].freeze

  def initialize(tour)
    super(page_size: PDF_SIZE)
    font_families.update("Muli" => {
      :normal => Rails.root.join("app/assets/fonts/Mulish-Regular.ttf").to_s,
      :bold => Rails.root.join("app/assets/fonts/Mulish-Bold.ttf").to_s,
      :black => Rails.root.join("app/assets/fonts/Mulish-Black.ttf").to_s
    })
    @tour = tour
    first_page
    start_new_page
    second_page
  end

  def first_page
    add_crop_marks
    font "Muli"
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    floor_plan = "https://www.cotala.com/tours/64025/Floorplan_Branded.jpg?r=1433302117"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    agent_headshot_url = @tour.agent_headshot_url
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 14 
#     [23.75, 775]
    font "Muli"
    text_box 'Listing Features', at: [680, 745], style: :normal
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [680, 720]
    rotate(270, origin: [550, 500]) do 
      image open(floor_plan), width: 750, height: 600, at: [305, 570]
    end
    
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.first_image}"),
          width: 550, height: 500, at: [640, 660]
    if agent_headshot_url
      bounding_box([675, 132], width: 400, height: 450) do
        image_width = 90
        image_height = 90
        crop_size = 0
        save_graphics_state do
          soft_mask do
            fill_color 0, 0, 0, 0
            fill_circle [45, 405], 45
          end
          image open(agent_headshot_url), at: [bounds.left, bounds.top], width: image_width, height: image_height
        end
      end
    end
    stroke_color 'b0b0b0'
    stroke_line [790, 130], [790, 40]
    text_box @tour.agent_name.to_s, at: [805, 135], style: :bold
    font_size 8
#     fill_color 'b0b0b0'
    text_box 'Personal Real Estate Corportation', at: [805, 110]
    font_size 18
#     fill_color '6c6d70'
    text_box @tour.agent_phone.to_s, at: [805, 95], style: :normal
    font_size 12
#     fill_color 'b0b0b0'
    text_box @tour.agent_email.to_s, at: [805, 70]
    text_box @tour.agent_url.to_s, at: [805, 55]
    image open(borker_log), fit: [75, 75], at: [1115, 70] if agent_headshot_url.present?
  end

  def second_page
    add_crop_marks
    qrcode = RQRCode::QRCode.new(@tour.hook_url.to_s)
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
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [38.75, 795]
    font_size 6
    text_box 'LISTED', at: [38.75, 746], style: :normal
    text_box 'FOR', at: [38.75, 736]
    font_size 24
    text_box "$#{@tour.price}", at: [63.75, 747], style: :bold
    font_size 8
    tour_description = @tour.description
    font_size 10
#     fill_color 'c1c1c1'
    font "Muli"
    text_box tour_description.to_s, at: [38.75, 690], width: 550, leading: 6, style: :normal
    font_size 18
#     fill_color 'c1c1c1'
    stroke_color '000000'
    stroke_line [38.75, 570], [588.75, 570]
#     text_box '_____________________________________________________________',
#              at: [38.75, 570]
#     text_box '_____________________________________________________________',
#              at: [38.75, 520]
    stroke_line [38.75, 542], [588.75, 542]
    font_size 12
    text_box 'LOT', at: [38.75, 565]
    text_box "#{@tour.lot_maint}   SF", at: [80, 565]
    text_box '|', at: [160, 565]
    text_box 'SIZE', at: [180, 565]
    text_box "#{@tour.size} SF", at: [225, 565]
    text_box '|', at: [290, 565]
    text_box @tour.bedrooms.to_s, at: [310, 565]
    text_box 'BED', at: [327, 565]
    text_box '|', at: [368, 565]
    text_box @tour.bathrooms.to_s, at: [388, 565]
    text_box 'BATH', at: [405, 565]
    text_box '|', at: [450, 565]
    text_box 'TAXES', at: [465, 565]
    text_box @tour.tax.to_s, at: [510, 565]
    #     text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}",
    #              at: [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.second_image}"
    image open(main_image), width: 550, height: 340, at: [38.75, 535]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.third_image}"),
          width: 180, height: 110, at: [38.75, 190]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourth_image}"),
          width: 180, height: 110, at: [223, 190]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifth_image}"),
          width: 180, height: 110, at: [408, 190]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.sixth_image}"),
          width: 550, height: 370, at: [650, 795]
    image open('/tmp/github-qrcode.png'),width: 60, height: 60, at: [1140, 797]
#     fill_color 'FFFFFF'
    font_size 6
    text_box "TAKE THE TOUR", at: [1148, 745]
    fill_color 'FFFFFF'
    fill { rectangle [1140, 737], 61, 10 }
    fill_color '6c6d70'
    text_box "cotala.com/#{@tour.cotala_tour_id}", at: [1146, 738]
#     text_box "cotala.com/#{@tour.cotala_tour_id}", at: [1135, 725]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.seventh_image}"),
          width: 180, height: 110, at: [650, 420]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eighth_image}"),
          width: 180, height: 110, at: [835, 420]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.ninth_image}"),
          width: 180, height: 110, at: [1020, 420]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.tenth_image}"),
          width: 180, height: 110, at: [650, 305]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eleventh_image}"),
          width: 180, height: 110, at: [835, 305]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.twelfth_image}"),
          width: 180, height: 110, at: [1020, 305]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.thirteenth_image}"),
          width: 180, height: 110, at: [650, 190]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourteenth_image}"),
          width: 180, height: 110, at: [835, 190]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifteenth_image}"),
          width: 180, height: 110, at: [1020, 190]
  end

  def add_crop_marks
    # top left
    stroke_line [-40, 795], [-10, 795] # left
    stroke_line [0, 850], [0, 810] # right
    # bottom left
    stroke_line [-40, 4], [-10, 4] # left
    stroke_line [0, -40], [0, -10] # right
    # top right
    stroke_line [1224.25, 850], [1224.25, 810] # left
    stroke_line [1265, 795], [1230, 795] # right
    # bottom right
    stroke_line [1224.25, -40], [1224.25, -10] # left
    stroke_line [1265, 4], [1230, 4] # right
  end
end
