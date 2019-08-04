class LinksController < ApplicationController
  def destroy
    @link= Link.find(params[:id])
    if can? :destroy, @link
      @link.destroy
    else
      redirect_to root_path, alert: 'Access denided'
    end
  end
end
