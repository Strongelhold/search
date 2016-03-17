module GdsHandler
  def self.parse(gds)
    gds.each do |one_gds|
      case one_gds
        when 'amadeus'
          #обработка
          puts "amadeus"
        when 'gabriel'
          #обработка
          @result = gabriel_handler
          puts @result
        when 'sirena'
          #Обработка
          puts "sirena"
        else
          #ошибка
          puts "error"
        end
    end
  end

  private

    def self.compaund(json_data)
      @index = 0 unless @result.to_a.empty?

      @result.insert(@index, json_data)
      @index += 1
      GdsHandler.result = @result
    end

    def self.gabriel_handler
      file = File.read('app/assets/GDS/gabriel.json')
      gabriel = JSON.parse(file)
      gabriel['flights'].each do |data|
        data['cost'] = get_amount(data['cost'])
      end
    end

    def self.get_amount(price)
      price += price/100.00
      price.round 2  #добавить вывод 2х знаков после запятой в случае 0 на конце
    end
end
