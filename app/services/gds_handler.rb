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
          return @result
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
    #Пока бесполезный метод. Удалить/поменять
    def self.compaund(json_data)
      @index = 0 unless @result.to_a.empty?

      @result.insert(@index, json_data)
      @index += 1
      GdsHandler.result = @result
    end

    def self.sirena_handler
      file = File.read('app/assets/GDS/sirena.yml')
      sirena = YAML.load(file)
      responce = []
      sirena.each do |data|
        result = Hash.new
        result['plane'] = data['plane_type']
        cost = data['total'].scan(/\d+/).first
        currency = data['total'].scan(/[a-zA-Z]+/).first
        result['cost'] = get_amount(cost.to_f)
        result['currency'] = currency
        result['time'] = data['at'].scan(/[0-9]+.:[0-9]+/).first
        responce << result
      end
      return responce
    end

    def self.amadeus_handler
      file = File.read('app/assets/GDS/amadeus.xml')
      amadeus = Hash.from_xml(file)
      responce = []
      amadeus['response']['routes'].each do |data|
        result = Hash.new
        result['plane'] =    data['aircraft'] 
        result['cost'] =     get_amount(data['price']['RUB'])
        result['currency'] = data['price'].key(data['price']['RUB'])
        result['time'] =     data['time']
        responce << result
      end
      return responce
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
