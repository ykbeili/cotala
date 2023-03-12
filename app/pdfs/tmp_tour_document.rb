class TmpTourDocument < Prawn::Document
  require 'open-uri'
  require 'rqrcode'
  PDF_SIZE = [1300, 870].freeze
  include ActionView::Helpers::NumberHelper

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
    if Faraday.head("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/Floorplan_Branded.jpg").status == 200
      floor_plan = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/Floorplan_Branded.jpg"
    else
      floor_plan = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/FullPublic.jpg"
    end
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    agent_headshot_url = @tour.agent_headshot_url if @tour.agent_headshot_url.present?
    agent_logo_url = @tour.agent_logo_url if @tour.agent_logo_url.present?
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'
    font_size 14 
    font "Muli"
    text_box 'Listing Features', at: [675, 745], style: :normal
    font_size 20
    text_box @tour.listing_address.upcase.to_s, at: [675, 720]
    if floor_plan.include? "FullPublic"
      image open("https://www.cotala.com/tours/67805/Floorplan_Branded.jpg"), fit: [750, 750], at: [26.75, 775]
    else
      if @tour.floorplan_orientation == 'vertical'
        image open(floor_plan), fit: [750, 750], at: [26.75, 775]
      else
        rotate(270, origin: [550, 500]) do 
          image open(floor_plan), width: 750, height: 600, at: [305, 570]
        end
      end
    end
    first_image = rename_image(@tour.first_image)
    p first_image
    p 'first_image'
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{first_image}"),
          width: 550, height: 500, at: [642, 660]
    if agent_headshot_url
      bounding_box([679, 132], width: 400, height: 450) do
        image_width = 90
        image_height = 90
        crop_size = 0
        save_graphics_state do
          soft_mask do
            fill_color 0, 0, 0, 0
            fill_circle [45, 405], 45
          end
          image open(agent_headshot_url), at: [bounds.left, bounds.top], width: image_width, height: image_height if Faraday.head(agent_headshot_url).status == 200
        end
      end
      stroke_color 'b0b0b0'
      stroke_line [785, 130], [785, 40]
      text_box @tour.agent_name.to_s, at: [800, 135], style: :bold
      font_size 8
      text_box 'Personal Real Estate Corportation', at: [800, 110] if @tour.prec == true
      font_size 18
      if @tour.prec == true
        text_box @tour.agent_phone.to_s, at: [800, 95], style: :normal
        font_size 12
        text_box @tour.agent_email.to_s, at: [800, 70]
        text_box @tour.agent_url.to_s, at: [800, 55]
      else
        text_box @tour.agent_phone.to_s, at: [800, 110], style: :normal
        font_size 12
        text_box @tour.agent_email.to_s, at: [800, 85]
        text_box @tour.agent_url.to_s, at: [800, 70]
      end

      else
      text_box @tour.agent_name.to_s, at: [665, 135], style: :bold
      font_size 8
      text_box 'Personal Real Estate Corportation', at: [665, 110] if @tour.prec == true 
      font_size 18
      if @tour.prec == true
        text_box @tour.agent_phone.to_s, at: [665, 95], style: :normal
        font_size 12
        text_box @tour.agent_email.to_s, at: [665, 70]
        text_box @tour.agent_url.to_s, at: [665, 55]
      else
        text_box @tour.agent_phone.to_s, at: [665, 110], style: :normal
        font_size 12
        text_box @tour.agent_email.to_s, at: [665, 85]
        text_box @tour.agent_url.to_s, at: [665, 70]
      end

      end
      image open(agent_logo_url), fit: [75, 75], at: [1115, 735] if agent_logo_url.present?
      image open(borker_log), fit: [75, 75], at: [1115, 110] if borker_log.present?
  end

  def second_page
    add_crop_marks
    qrcode = RQRCode::QRCode.new("https://cotala.com/#{@tour.cotala_tour_id}")
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
    qrcode_image = IO.binwrite("/tmp/#{@tour.cotala_tour_id}.png", qrcode_to_png.to_s)
    fill_color '000000' if @tour.selected_theme == 'dark'
    fill_rectangle [-35, 1056], 1632, 1096 if @tour.selected_theme == 'dark'
    fill_color @tour.selected_theme == 'dark' ? 'FFFFFF' : '6c6d70'

    font_size 8
    tour_description = @tour.description
    if tour_description.length > 700
      font_size 9
      text_box tour_description.to_s, at: [32.75, 660], width: 550, height: 135, leading: 6, style: :normal
      font_size 20
      text_box @tour.listing_address.upcase.to_s, at: [32.75, 765]
      font_size 6
      text_box 'LISTED', at: [37.75, 710], style: :normal
      text_box 'FOR', at: [37.75, 700]
      font_size 24
      text_box "$#{number_with_delimiter(@tour.price, delimiter: ",")}", at: [63.75, 715], style: :bold
    else
      font_size 9
      text_box tour_description.to_s, at: [32.75, 653], width: 550, height: 120, leading: 5, style: :normal
      # stroke_line [30.75, 533], [580.75, 533]
      # stroke_line [30.75, 505], [580.75, 505]
      font_size 20
      text_box @tour.listing_address.upcase.to_s, at: [32.75, 758]
      font_size 6
      text_box 'LISTED', at: [37.75, 705], style: :normal
      text_box 'FOR', at: [37.75, 695]
      font_size 24
      text_box "$#{number_with_delimiter(@tour.price, delimiter: ",")}", at: [63.75, 710], style: :bold
    end
    font_size 10
    font "Muli"
    font_size 18
    stroke_color '000000'
    font_size 11
    lot_or_main_value = @tour.lot_maint.to_s.sub(/\.?0+$/, '').to_i
    if @tour.lot_or_maint == true
      text_box 'LOT', at: [29.75, 528]
      text_box "#{number_with_delimiter(lot_or_main_value, delimiter: ',')}", at: [69, 528]
    else
      text_box 'MAINT', at: [29.75, 528]
      text_box "#{@tour.lot_maint}", at: [74, 528]
    end
    text_box '|', at: [145, 528]
    text_box 'SIZE', at: [165, 528]
    if @tour.size == 'see floorplan' || @tour.size == 'see plan' 
      text_box "#{@tour.size}", at: [210, 528]
    else
      text_box "#{@tour.size}", at: [210, 528]
    end
    text_box '|', at: [275, 528]
    text_box @tour.bedrooms.to_s, at: [295, 528]
    text_box 'BED', at: [312, 528]
    text_box '|', at: [353, 528]
    text_box @tour.bathrooms.to_s, at: [373, 528]
    text_box 'BATH', at: [388, 528]
    text_box '|', at: [435, 528]
    text_box 'TAXES', at: [454, 528]
    text_box "#{@tour.tax.to_s}", at: [505, 528]
    second_image = rename_image(@tour.second_image)
    third_image = rename_image(@tour.third_image)
    fourth_image = rename_image(@tour.fourth_image)
    fifth_image = rename_image(@tour.fifth_image)
    sixth_image = rename_image(@tour.sixth_image)
    seventh_image = rename_image(@tour.seventh_image)
    eighth_image = rename_image(@tour.eighth_image)
    ninth_image = rename_image(@tour.ninth_image)
    tenth_image = rename_image(@tour.tenth_image)
    eleventh_image = rename_image(@tour.eleventh_image)
    twelfth_image = rename_image(@tour.twelfth_image)
    thirteenth_image = rename_image(@tour.thirteenth_image)
    fourteenth_image = rename_image(@tour.fourteenth_image)
    fifteenth_image = rename_image(@tour.fifteenth_image)
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{second_image}"
    image open(main_image), width: 550, height: 340, at: [30.75, 498]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{third_image}"),
          width: 180, height: 110, at: [30.75, 153]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{fourth_image}"),
          width: 180, height: 110, at: [215, 153]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{fifth_image}"),
          width: 180, height: 110, at: [400, 153]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{sixth_image}"),
          width: 550, height: 370, at: [645, 758]
    image open("/tmp/#{@tour.cotala_tour_id}.png"),width: 65, height: 65, at: [1139, 766]
    font_size 6
    text_box "TAKE THE TOUR", at: [1148, 708]
    fill_color 'FFFFFF'
    fill { rectangle [1139, 701], 61, 10 }
    fill_color '6c6d70'
    text_box "cotala.com/#{@tour.cotala_tour_id}", at: [1147, 700]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{seventh_image}"),
          width: 180, height: 110, at: [645, 383]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{eighth_image}"),
          width: 180, height: 110, at: [830, 383]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{ninth_image}"),
          width: 180, height: 110, at: [1015, 383]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{tenth_image}"),
          width: 180, height: 110, at: [645, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{eleventh_image}"),
          width: 180, height: 110, at: [830, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{twelfth_image}"),
          width: 180, height: 110, at: [1015, 268]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{thirteenth_image}"),
          width: 180, height: 110, at: [645, 153]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{fourteenth_image}"),
          width: 180, height: 110, at: [830, 153]
    image open("https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{fifteenth_image}"),
          width: 180, height: 110, at: [1015, 153]
  end

  def rename_image(image_name)
    new_image_name = image_name.split(".")
    new_image_name[0] = new_image_name[0] + "_thm"
    return new_image_name.join(".")
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
