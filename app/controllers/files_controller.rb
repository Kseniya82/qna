class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    if can? :destroy, @file
      @file.purge
    else
      redirect_to root_path, alert: 'Access denided'
    end
  end
end
