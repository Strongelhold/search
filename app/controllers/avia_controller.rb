class AviaController < ApplicationController
  def search
    if (params[:date].nil? && params[:gds].nil?)
      render json: {"result" => "Empty request", "elapsed" => 0.0, "items" => []}
      return false
    end
    if (params[:gds].nil?)
      render json: {"result" => "Empty GDS request", "elapsed" => 0.0, "items" => []}
      return false
    end
    if (params[:date].nil?)
      render json: {"result" => "Empty date request", "elapsed" => 0.0, "items" => []}
      return false
    end
    
    result = Avia.search(params[:date],params[:gds])
    render json: result.to_json
  end
end
