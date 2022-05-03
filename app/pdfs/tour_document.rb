class TourDocument < Prawn::Document
  require 'open-uri'
  require 'rqrcode'
  PDF_SIZE = [1270, 870].freeze

  def initialize(tour)
    super(page_size: PDF_SIZE)
    @tour = tour
    first_page
    start_new_page
    second_page
  end

  def first_page
    stroke_axis
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    floor_plan = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/Floorplan_Branded.jpg"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    agent_headshot_url = @tour.agent_headshot_url
    add_crop_marks
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 14
    text_box 'Listing Features', at: [760, 700], style: 'normal'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [660, 675], style: 'bold'
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.first_image}"),
          width: 542, height: 475, at: [640, 652]
    if agent_headshot_url
      bounding_box([645, 150], width: 400, height: 450) do
        image_width = 150
        image_height = 150
        crop_size = 100
        save_graphics_state do
          soft_mask do
            fill_color 0, 0, 0, 0
            fill_circle [68, 390], 55
          end
          image open(agent_headshot_url), at: [bounds.left, bounds.top], width: image_width, height: image_height
        end
      end
    end
    stroke_line [790, 145], [790, 35]
    text_box @tour.agent_name.to_s, at: [810, 140]
    font_size 8
    fill_color 'b0b0b0'
    text_box 'Personal Real Estate Corportation', at: [810, 115]
    font_size 18
    fill_color '6c6d70'
    text_box @tour.agent_phone.to_s, at: [810, 100], style: 'normal'
    font_size 8
    fill_color 'b0b0b0'
    text_box @tour.agent_email.to_s, at: [810, 75]
    text_box @tour.agent_url.to_s, at: [810, 40]
    image open(borker_log), fit: [100, 100], at: [1230, 118] if agent_headshot_url.present?
  end

  def second_page
#     font_families.update(
#       'Muli' => {
#         normal: "#{Prawn::DATADIR}/fonts/Muli.ttf"
#       }
#     )
#     font 'Muli'
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
    add_crop_marks
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [23.75, 775]
    font_size 6
    text_box 'LISTED', at: [23.75, 726], style: 'normal'
    text_box 'FOR', at: [23.75, 715]
    font_size 24
    text_box "$#{@tour.price}", at: [48.75, 724], style: 'bolder'
    font_size 8
    tour_description = @tour.description
    font_size 10
    fill_color 'c1c1c1'
    text_box tour_description.to_s, at: [23.75, 670], width: 500, leading: 6, style: 'normal'
    font_size 18
    fill_color 'b0b0b0'
    text_box '_______________________________________________________',
             at: [23.75, 550]
    text_box '_______________________________________________________',
             at: [23.75, 520]
    font_size 12
    text_box 'LOT', at: [23.75, 525]
    text_box "#{@tour.lot_maint} SF", at: [68.75, 525]
    text_box '|', at: [150, 525]
    text_box 'SIZE', at: [170, 525]
    text_box "#{@tour.size} SF", at: [220, 525]
    text_box '|', at: [295, 525]
    text_box @tour.bedrooms.to_s, at: [315, 525]
    text_box 'BED', at: [325, 525]
    text_box '|', at: [360, 525]
    text_box @tour.bathrooms.to_s, at: [370, 525]
    text_box 'BATH', at: [380, 525]
    text_box '|', at: [425, 525]
    text_box 'TAXES', at: [450, 525]
    text_box @tour.tax.to_s, at: [500, 525]
    #     text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}",
    #              at: [40, 650]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.second_image}"
    image open(main_image), width: 550, height: 350, at: [23.75, 495]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.third_image}"),
          width: 180, height: 120, at: [23.75, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourth_image}"),
          width: 180, height: 120, at: [208, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifth_image}"),
          width: 180, height: 120, at: [393, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.sixth_image}"),
          width: 550, height: 375, at: [635, 775]
    image open('/tmp/github-qrcode.png'), at: [1410, 960]

    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.seventh_image}"),
          width: 180, height: 120, at: [635, 395]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eighth_image}"),
          width: 180, height: 120, at: [820, 395]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.ninth_image}"),
          width: 180, height: 120, at: [1005, 395]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.tenth_image}"),
          width: 180, height: 120, at: [635, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.eleventh_image}"),
          width: 180, height: 120, at: [820, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.twelfth_image}"),
          width: 180, height: 120, at: [1005, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.thirteenth_image}"),
          width: 180, height: 120, at: [635, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fourteenth_image}"),
          width: 180, height: 120, at: [820, 140]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.fifteenth_image}"),
          width: 180, height: 120, at: [1005, 140]
  end

  def add_crop_marks
    # top left
    stroke_line [-40, 800], [-20, 800] # left
    stroke_line [-15, 850], [-15, 815] # right
    # bottom left
    stroke_line [-40, 0], [-15, 0] # left
    stroke_line [-15, -40], [-15, -15] # right
    # top right
    stroke_line [1215, 850], [1215, 815] # left
    stroke_line [1250, 800], [1220, 800] # right
    # bottom right
    stroke_line [1215, -40], [1215, -10] # left
    stroke_line [1250, 0], [1220, 0] # right
  end
end
