class TourDocument < Prawn::Document
  require "open-uri"
  def initialize(tour)
    super(:page_size => 'A2')
    @tour = tour
    first_page
    second_page
  end
  
  def first_page
    stroke_axis
    floor_plan = "https://images.squarespace-cdn.com/content/v1/5bdde6530dbda3230ba6bd5d/1542039146291-IY4AG1D0JN2D1400BZ1C/Matterport+-+Best+Practices+for+Schematic+Floor+Plans.jpg?format=1000w"
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    broker_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[1].name}"
    borker_log = @tour.broker_logo
    image open(floor_plan), :width => 650, :height => 1600
    fill_color '6c6d70'
    font_size 16
    text_box "Listing Features", :at => [650, 1525], style: "normal"
    font_size 20
    text_box "#{@tour.listing_address}", :at => [650, 1500]
    image open(borker_log), :width => 100, :height => 100, :at => [1050,1550]
    image open(main_image), :width => 450, :height => 600, :at => [650, 1400]
    text_box "#{@tour.agent_name}", :at => [760, 300]
    font_size 8
    text_box "Personal Real Estate Corportation", :at => [760, 275]
    font_size 20
    text_box "#{@tour.agent_phone}", :at => [760, 250]
    font_size 8
    text_box "#{@tour.agent_email}", :at => [760, 220]
    text_box "#{@tour.agent_url}", :at => [760, 200]
    image open(broker_image), :width => 100, :height => 200, :at => [650,300]
    image open(borker_log), :width => 200, :height => 100, :at => [950,250]
    start_new_page
  end

  def second_page
    fill_color '6c6d70'
    font_size 20
    text_box "#{@tour.listing_address}", :at => [30, 1550]
    text_box "Listed for: $#{@tour.price}", :at => [30, 1500], style: "bold"
    font_size 8
    tour_description = @tour.description
    formatted_tour_description = @tour.description.split(" ")
    first_chapter = []
    second_chapter = []
    third_chapter = []
    fourth_chapter = []
    fifth_chapter = []
    formatted_tour_description.each_with_index do |c, index|
      if index < formatted_tour_description.count / 5
        first_chapter.push(c)
        next
      elsif index < formatted_tour_description.count / 4
        second_chapter.push(c)
        next
      elsif index < formatted_tour_description.count / 3
        third_chapter.push(c)
        next
      elsif index < formatted_tour_description.count / 2
        fourth_chapter.push(c)
        next
      else
        fifth_chapter.push(c)
        next
      end
    end
    text_box "#{first_chapter.join(' ')}}", :at => [30, 1450]
    text_box "#{second_chapter.join(' ')}", :at => [30, 1440]
    text_box "#{third_chapter.join(' ')}}", :at => [30, 1430]
    text_box "#{fourth_chapter.join(' ')}", :at => [30, 1420]
    text_box "#{fifth_chapter.join(' ')}", :at => [30, 1410]
    font_size 16
    text_box "LOT | #{@tour.mls} | SIZE #{@tour.size} SF | #{@tour.bedrooms} BED | #{@tour.bathrooms} BATH | TAXES #{@tour.tax}", :at => [30, 1350]
    main_image = "https://www.cotala.com/tours/#{@tour.cotala_tour_id}/#{@tour.cotala_tour_id}_#{@tour.images[0].name}"
    image open(main_image), :width => 600, :height => 400, :at => [30,1300]
    image open(main_image), :width => 190, :height => 100, :at => [30, 890]
    image open(main_image), :width => 190, :height => 100, :at => [235, 890]
    image open(main_image), :width => 190, :height => 100, :at => [440, 890]
    image open(main_image), :width => 500, :height => 400, :at => [650, 1400]
    image open(main_image), :width => 190, :height => 100, :at => [650, 890]
    image open(main_image), :width => 190, :height => 100, :at => [850, 890]
    image open(main_image), :width => 190, :height => 100, :at => [1050, 890]
    image open(main_image), :width => 190, :height => 100, :at => [650, 790]
    image open(main_image), :width => 190, :height => 100, :at => [850, 790]
    image open(main_image), :width => 190, :height => 100, :at => [1050, 790]
    image open(main_image), :width => 190, :height => 100, :at => [650, 690]
    image open(main_image), :width => 190, :height => 100, :at => [850, 690]
    image open(main_image), :width => 190, :height => 100, :at => [1050, 690]
  end
end
