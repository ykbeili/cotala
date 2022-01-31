class ToursController < ApplicationController
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http
  include Wicked::Wizard
  steps :step1, :step2, :step3, :step4

  def index
    # conn = Faraday.new do |f|
    #   f.request :json # encode req bodies as JSON
    #   # f.request :retry # retry transient failures
    #   f.response :json # decode response bodies as JSON
    #   f.adapter :net_http # Use the Net::HTTP adapter
    # end
    # @response = conn.get('https://www.cotala.com/printjobs/86588/data.txt')
    # https://www.cotala.com/printjobs/86588/data.txt
    # https://www.cotala.com/printjobs/86697/data.txt
    # https://www.cotala.com/printjobs/86688/data.txt
    random_array = [86_588, 86_697, 86_688]
    @response = Faraday.get("https://www.cotala.com/printjobs/#{random_array.sample}/data.txt")
    @header_elements = []
    @body_elemets = []
    array = @response.body.split("\t")
    array.each_with_index do |e, index|
      if index < array.count / 2
        @header_elements.push(e)
      else
        @body_elemets.push(e)
      end
    end
    [@header_elements, @body_elemets]
  end

  def step1
    # render_wizard
  end

  def show
    render_wizard
  end
end
