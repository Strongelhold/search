module GdsHandler

  def self.handle(gds)
    start_time = Time.now.to_f
    @result  = []
    @error = ""
    gds.each do |one_gds|
      response = []
      case one_gds
        when 'amadeus'
          response = amadeus_handler
        when 'gabriel'
          response = gabriel_handler
        when 'sirena'
          response = sirena_handler
        else
          @error ="#{one_gds} not found"
        end
      response.each do |data|
        @result << data
      end
    end
    if @error.empty? && !@result.empty?
      end_time = Time.now.to_f
      end_time -= start_time
      answer = Hash.new
      answer['result'] = 'success'
      answer['elapsed'] = end_time.round 2
      answer['items'] = @result
      return answer
    else

    end
  end

  private

    def self.sirena_handler
      file = File.read('app/assets/GDS/sirena.yml')
      sirena = YAML.load(file)
      response = []
      sirena.each do |data|
        result =             Hash.new
        result['plane'] =    data['plane_type']
        cost =               data['total'].scan(/\d+/).first
        currency =           data['total'].scan(/[a-zA-Z]+/).first
        result['cost'] =     get_amount(cost.to_f)
        result['currency'] = currency
        result['time'] =     data['at'].scan(/[0-9]+.:[0-9]+/).first
        response << result
      end
      return response
    end

    def self.amadeus_handler
      file = File.read('app/assets/GDS/amadeus.xml')
      amadeus = Hash.from_xml(file)
      response = []
      amadeus['response']['routes'].each do |data|
        result =             Hash.new
        result['plane'] =    data['aircraft'] 
        result['cost'] =     get_amount(data['price']['RUB'])
        result['currency'] = data['price'].key(data['price']['RUB'])
        result['time'] =     data['time']
        response << result
      end
      return response
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
      price.round 2
    end

end
