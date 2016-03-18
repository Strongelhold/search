require "rails_helper"

describe "Avia" do
  before do
    @correct_date = '26-07-2016'
    @incorrect_date = '18-03-2016'
    @empty_date = ""
    @wrong_date = 12
    @correct_gds = ['sirena', 'gabriel', 'amadeus']
    @incorrect_gds = ['foo', 'bar', 'baz']
    @empty_gds = []
    @wrong_gds = 2
  end

  describe "search method" do
    describe "must return not nil answer" do
      result = Avia.search(@correct_date, @correct_gds)
      it { should_not be_nil }
    end

    it "must return 'success' answer" do
      result = Avia.search(@correct_date, @correct_gds)
      expect(result['result'] == 'success').to be true
    end

    it "must return incorrect date error answer" do
      result = Avia.search(@incorrect_date, @incorrect_gds)
      expect(result['result'] == 'Date is not correct').to be true
    end

    it "must return empty date error" do
      result = Avia.search(@empty_date, @correct_gds)
      expect(result['result'] == 'Date is empty').to be true
    end
    
    it "must return ArgumentError message when date not a string" do
      result = Avia.search(@wrong_date, @correct_gds)
      expect(result['result'].to_s == 'Date must be a String').to be true
    end

    it "must return GDS empty error" do
      result = Avia.search(@correct_date, @empty_gds)
      expect(result['result'] == 'GDS list empty').to be true
    end
    
    it "must return unknow gds error" do
      result = Avia.search(@correct_date, @incorrect_gds)
      expect(result['result'] == 'Unknow GDS').to be true
    end
    
    it "must return ArgumentError when GDS not array" do
      result = Avia.search(@correct_date, @wrong_gds)
      expect(result['result'].to_s == "You must give GDS array").to be true
    end
    
    it "result['items'] must be array" do
      result = Avia.search(@correct_date, @correct_gds)
      expect(result['items'].kind_of?(Array)).to be true
    end

    it "answer must have correct format" do
      result = Avia.search(@correct_date, @correct_gds)
      expect(result.to_s.scan(/{"result"=>"[a-zA-Z]+", "elapsed"=>\d+.\d+, "items"=>/).first.empty?).not_to be true
    end

  end
  
end
