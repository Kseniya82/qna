class SearchController < ApplicationController

  def results
    @query = query_params
    @results = Services::Search.new.call(@query)
  end

  private

  def query_params
    params.permit(:query, :scope)
  end
end
