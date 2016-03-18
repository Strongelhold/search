class AviaController < ApplicationController
  def search
    result = Avia.search(params[:date],params[:gds])
    render json: result
  end
end
