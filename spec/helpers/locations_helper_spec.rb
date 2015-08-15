require 'rails_helper'
require 'httparty'

# Specs in this file have access to a helper object that includes
# the LocationHelper. For example:
#
# describe LocationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe LocationHelper, type: :helper do
  describe 'build_location' do
    let(:attr) { HTTParty.get('http://api.openweathermap.org/data/2.5/weather?q=Berlin,de') }

    it 'works like a charm' do
      expect(helper.build_location(attr)).to be_valid
    end
  end

  describe 'convert_to_unit_of_measurement' do
    [['metric', 'Celsius'], ['imperial', 'Fahrenheit'], ['', 'Kelvin']].each do |unit|
      it 'converts to correct unit of measurement' do
        expect(helper.convert_to_unit_of_measurement(unit[0])).to eq unit[1]
      end
    end
  end
end

