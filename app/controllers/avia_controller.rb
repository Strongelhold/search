class AviaController < ApplicationController
  def search
    if (params[:date].nil? || params[:gds].nil?)
      render json: {"result" => "Empty request", "elapsed" => 0.0, "items" => []}
    else
      result = Avia.search(params[:date],params[:gds])
      render json: result.to_json
    end
  end
end
