class TourDocumentJob < ApplicationJob
  queue_as :default
  FTP_LINK = 'ftp.cotala.com'.freeze
  require 'net/ftp'

  def perform(id)
    @tour = Tour.find id
    @pdf = TourDocument.new(@tour)
    ftp = Net::FTP.new(FTP_LINK)
    ftp.login('tam@cotala.com', 'B*22?Rpdlen+')
    file_path = "#{Rails.root}/tmp/#{@tour.agent_name}-#{@tour.cotala_tour_id}.pdf"
    @pdf.render_file file_path
    version = @tour.version || 2
    ftp.putbinaryfile(file_path, "#{@tour.print_job_id}/#{@tour.print_job_id}-#{version}-b.pdf")
    ftp.close
  end
end