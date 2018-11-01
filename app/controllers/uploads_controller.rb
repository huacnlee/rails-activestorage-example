class UploadsController < ApplicationController
  before_action :require_disk_service!
  before_action :set_blob

  # GET /upload/:id
  # GET /upload/:id?s=large
  def show
    if params[:s]
      # generate thumb
      variation_key = Blob.variation(params[:s])
      send_file_by_disk_key @blob.representation(variation_key).processed.key, content_type: @blob.content_type
    else
      # return raw file
      send_file_by_disk_key @blob.key, content_type: @blob.content_type, disposition: params[:disposition], filename: @blob.filename
    end
  end

  private

    def send_file_by_disk_key(key, content_type:, disposition: :inline, filename: nil)
      opts = { type: content_type, disposition: disposition, filename: filename }
      send_file Blob.path_for(key), opts
    end

    def set_blob
      @blob = ActiveStorage::Blob.find_by(key: params[:id])
      head :not_found if @blob.blank?
    end

    def require_disk_service!
      head :not_found unless Blob.disk_service?
    end
end
