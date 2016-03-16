class Searcher < ActiveRecord::Base
  def self.search(date, gds)
    date = Date.parse(date)
    if date <= Date.today
      #обработка ошибок вывод сообщений
      false
    else
      if gds.nil?
        #обработка ошибок, вывод сообщений
        false
      else
        
      end
    end
  end
end
