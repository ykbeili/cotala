class TourDocument < Prawn::Document
  require "open-uri"
  def initialize(tour)
    super(:page_size => 'A2')
    @tour = tour
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
    text 'page 2', align: :center, valign: :top
    # bounding_box([100, 300], width: 300, height: 200) do
    #   stroke_bounds
    #   stroke_circle [0, 0], 10
    # end
  end
end
