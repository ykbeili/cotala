class ToursController < ApplicationController
  require 'faraday/net_http'
  Faraday.default_adapter = :net_http
  def index
    # conn = Faraday.new do |f|
    #   f.request :json # encode req bodies as JSON
    #   # f.request :retry # retry transient failures
    #   f.response :json # decode response bodies as JSON
    #   f.adapter :net_http # Use the Net::HTTP adapter
    # end
    # @response = conn.get('https://www.cotala.com/printjobs/86588/data.txt')
    @response = Faraday.get('https://www.cotala.com/printjobs/86588/data.txt')
    @header_elements = []
    @body_elemets = []
    array = @response.body.split("\t")
    p array.count / 2
    p 'array'
    array.each_with_index do |e, index|
      p index
      p 'index'
      if index < array.count / 2
        @header_elements.push(e)
      else
        @body_elemets.push(e)
      end
    end
    [@header_elements, @body_elemets]
  end
end
