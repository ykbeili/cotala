class TourDocument < Prawn::Document
  def initialize
    super
    text 'page 1', align: :center, valign: :top
    start_new_page
    text 'page 2', align: :center, valign: :top
    # text 'text right', align: :center, valign: :top
    # stroke_axis
    # stroke_circle [0, 0], 10
    # bounding_box([100, 300], width: 300, height: 200) do
    #   stroke_bounds
    #   stroke_circle [0, 0], 10
    # end
  end
end
