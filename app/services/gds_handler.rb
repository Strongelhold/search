module GdsHandler

  def self.handle(gds)
    start_time = Time.now.to_f
    @result  = []
    @error = ""
    if gds.empty? || gds.nil?
      end_time = Time.now.to_f
      end_time -= start_time
      @error = "GDS list empty"
      return get_answer(@error, end_time.round(2), [])
    else
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
            @error ="Unknow GDS"
          end
        response.each do |data|
          @result << data
        end
      end
      if @error.empty? && !@result.empty?
        end_time = Time.now.to_f
        end_time -= start_time
        return get_answer('success', end_time.round(2), @result)
      else
        end_time = Time.now.to_f
        end_time -= start_time
        return get_answer(@error, end_time.round(2), [])
      end
    end
  end

  private

    def self.sirena_handler
      file = File.read('app/assets/GDS/sirena.yml')
      sirena = YAML.load(file)
      response = []
      sirena.each do |data|
        result = Hash.new
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
        result = Hash.new
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

    def self.get_answer(result, time, gds_response_array)
      answer = Hash.new
      answer['result'] =  result
      answer['elapsed'] = time
      answer['items'] =   gds_response_array
      return answer
    end
end
