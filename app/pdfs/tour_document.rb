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
    image open(main_image), :width => 550, :height => 800, :at => [650, 1300]
    image open(borker_log), :width => 200, :height => 200, :at => [1000,1500]
    image open(borker_log), :width => 200, :height => 200, :at => [1000,1500]
    image open(broker_image), :width => 200, :height => 200, :at => [650,300]
    text_box "#{@tour.agent_name}\n Personal Real Estate Corportation", :at => [750, 300]
    text_box "#{@tour.agent_phone}", :at => [750, 250]
    text_box "#{@tour.agent_email}", :at => [750, 200]
    text_box "#{@tour.agent_url}", :at => [750, 150]
    text_box "#{@tour.listing_address}", :at => [750, 1500]
    start_new_page
    text 'page 2', align: :center, valign: :top
    # bounding_box([100, 300], width: 300, height: 200) do
    #   stroke_bounds
    #   stroke_circle [0, 0], 10
    # end
  end
end
