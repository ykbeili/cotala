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
    font "Muli"
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    floor_plan = "https://www.cotala.com/tours/64025/Floorplan_Branded.jpg?r=1433302117"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    agent_headshot_url = @tour.agent_headshot_url
    add_crop_marks
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 14 
#     [23.75, 775]
    font "Muli"
    text_box 'Listing Features', at: [670, 725], style: :normal
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [670, 700]
    rotate(270, origin: [550, 500]) do 
      image open(floor_plan), width: 750, height: 600, at: [305, 550]
    end
    
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.first_image}"),
          width: 550, height: 500, at: [640, 640]
    if agent_headshot_url
      bounding_box([665, 112], width: 400, height: 450) do
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
    stroke_line [780, 110], [780, 20]
    text_box @tour.agent_name.to_s, at: [795, 115], style: :bold
    font_size 8
    fill_color 'b0b0b0'
    text_box 'Personal Real Estate Corportation', at: [795, 90]
    font_size 18
    fill_color '6c6d70'
    text_box @tour.agent_phone.to_s, at: [795, 75], style: :normal
    font_size 12
    fill_color 'b0b0b0'
    text_box @tour.agent_email.to_s, at: [795, 50]
    text_box @tour.agent_url.to_s, at: [795, 35]
    image open(borker_log), fit: [75, 75], at: [1115, 50] if agent_headshot_url.present?
  end

  def second_page
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
    add_crop_marks
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [28.75, 775]
    font_size 6
    text_box 'LISTED', at: [28.75, 726], style: :normal
    text_box 'FOR', at: [28.75, 716]
    font_size 24
    text_box "$#{@tour.price}", at: [53.75, 727], style: :bold
    font_size 8
    tour_description = @tour.description
    font_size 10
    fill_color 'c1c1c1'
    font "Muli"
    text_box tour_description.to_s, at: [28.75, 670], width: 550, leading: 6, style: :normal
    font_size 18
    fill_color 'b0b0b0'
    text_box '____________________________________________________________',
             at: [28.75, 550]
    text_box '____________________________________________________________',
             at: [28.75, 520]
    font_size 12
    text_box 'LOT', at: [28.75, 525]
    text_box "#{@tour.lot_maint}   SF", at: [70, 525]
    text_box '|', at: [150, 525]
    text_box 'SIZE', at: [170, 525]
    text_box "#{@tour.size} SF", at: [215, 525]
    text_box '|', at: [280, 525]
    text_box @tour.bedrooms.to_s, at: [300, 525]
    text_box 'BED', at: [317, 525]
    text_box '|', at: [358, 525]
    text_box @tour.bathrooms.to_s, at: [378, 525]
    text_box 'BATH', at: [395, 525]
    text_box '|', at: [440, 525]
    text_box 'TAXES', at: [455, 525]
    text_box @tour.tax.to_s, at: [507, 525]
    #     text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}",
    #              at: [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.second_image}"
    image open(main_image), width: 550, height: 350, at: [28.75, 495]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.third_image}"),
          width: 180, height: 120, at: [28.75, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourth_image}"),
          width: 180, height: 120, at: [213, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifth_image}"),
          width: 180, height: 120, at: [398, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.sixth_image}"),
          width: 550, height: 380, at: [640, 775]
    image open('/tmp/github-qrcode.png'),width: 60, height: 60, at: [1130, 775]

    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.seventh_image}"),
          width: 180, height: 120, at: [640, 390]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eighth_image}"),
          width: 180, height: 120, at: [825, 390]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.ninth_image}"),
          width: 180, height: 120, at: [1010, 390]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.tenth_image}"),
          width: 180, height: 120, at: [640, 265]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eleventh_image}"),
          width: 180, height: 120, at: [825, 265]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.twelfth_image}"),
          width: 180, height: 120, at: [1010, 265]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.thirteenth_image}"),
          width: 180, height: 120, at: [640, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourteenth_image}"),
          width: 180, height: 120, at: [825, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifteenth_image}"),
          width: 180, height: 120, at: [1010, 140]
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
