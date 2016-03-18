class Avia < ActiveRecord::Base
  include GdsHandler

  def self.search(date, gds)
    raise ArgumentError.new('Date must be a String') unless date.kind_of?(String) 
    if date.empty?
      error = "Date is empty"
      GdsHandler.get_answer(error, 0.0, [])
    else
      date = Date.parse(date)
      if (date <= Date.today)
        error = "Date is not correct"
        GdsHandler.get_answer(error, 0.0, [])
      else
        GdsHandler.handle(gds)   
      end
    end
    rescue Exception => error
      return GdsHandler.get_answer(error, 0.0, [])
  end
end
