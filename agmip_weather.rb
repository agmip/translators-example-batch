require 'java'
Dir['lib/*.jar'].each { |j| require j}
require 'date'
java_require 'agmip_weather'

module AgMIP
  module Translators
    # AgMIP Weather File Translator
    # @author Christopher Villalobos <cvillalobos@ufl.edu>
    class AgmipWeather
      include_package "org.agmip.core.types"
      include org.agmip.core.types.WeatherFile
      attr_accessor :data
      attr_accessor :location
      # Default value used if a value is missing
      @@default_value = -99.99

      def initialize
        @data = Array.new
        @location = nil
      end

      # AgMIP file reader
      # @param [String] Source file path
      def readFile(file)
        puts "Reading file " + file + ' [AgMIP]'
        fh = File.open(file)
        # Populate the extra_data with the Location header
        extra_data = fh.readline.split(':')[1].strip
        # Skip two lines
        2.times {fh.readline}
        # Process the location specific information into memory
        loc_line = fh.readline
        loc_data = loc_line.split(' ')
        @location = WeatherLocation.new(PointLocation.new(loc_data.shift.strip, Point.new(loc_data.shift.strip.to_f, loc_data.shift.strip.to_f), loc_data.shift.strip.to_f))
        loc_data.each_with_index{ |v, k|
          loc_data[k] = ( v.strip == @@default_value ) ? nil : v.strip.to_f 
        }
        @location.set_temp_average(loc_data[0])
        @location.set_temp_amplitude(loc_data[1])
        @location.set_reference_height(loc_data[2])
        @location.set_wind_height(loc_data[3])
        @location.set_extra_data(java.util.HashMap.new({"location_detail" => extra_data}))
        fh.readline
        # Process each line and extract dailiy weather information
        fh.each { |line|
          line_data = line.split(' ')
          line_data.shift
          line_date = Date.new(line_data.shift.to_i, line_data.shift.to_i, line_data.shift.to_i)
          line_data.each_with_index{ |v,k| line_data[k] = (v == @@default_value ) ? nil : v.to_f }
          weather_data = { "date" => line_date, 
                   "srad" => line_data[0],
                   "tmax" => line_data[1],
                   "tmin" => line_data[2],
                   "rain" => line_data[3],
                   "wind" => line_data[4],
                   "dewp" => line_data[5],
                   "vprs" => line_data[6],
                   "rhum" => line_data[7] }
          @data.push(WeatherDataLine.new(java.util.HashMap.new(weather_data))) 
        }
        fh.close
      end
      
      # AgMIP File Reader
      def writeFile(file)
        puts "Writing file " + file + "[AgMIP]"
      end
    end
  end
end
