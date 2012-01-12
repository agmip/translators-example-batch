require 'java'
require 'lib/agmip-core-1.0-SNAPSHOT.jar'

module AgMIP
  module Translators
    class SticsWeather
      include_package "org.agmip.core.types"
      include org.agmip.core.types.WeatherFile
      attr_accessor :data
      @location = nil
      @@default_value = -999.9
      
      def initialize
        @data = Array.new
      end

      def readFile(file)
        puts "Reading file " + file
        #We can check the first line to make sure it matches our translator
        fh = File.open(file)
        line = fh.readline
        loc = ''
        if( check(line) )
          loc = line.split(' ')[0]
          @location = WeatherLocation.new(PointLocation.new(loc, Point.new(@@default_value, @@default_value), @@default_value))
          fh.rewind
          # process the files here
          fh.each{ |line|
            line_data = line.split(' ')
            line_data.each_with_index{ |v, k| line_data[k] = (v == @@default_value.to_s) ? nil : v.to_f }
            weather_data = WeatherDataLine.new(java.util.HashMap.new({}))
            weather_data.set_temp_min(line_data[5])
            weather_data.set_temp_max(line_data[6])
            weather_data.set_solar_radiation(line_data[7])
            weather_data.set_rain(line_data[9])
            @data.push(weather_data)
          }
        end
        fh.close
      end

      def writeFile(file)
        puts "Writing file " + file + "[STICS]"
        @data.each { |dl|
          puts(':::'+dl.get_temp_max.to_s)
        }
      end

      def check(line)
        re = /\S*\s+\d{4}\s+\d{1,2}\s+\d{1,2}\s+\d{1,3}\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+\s+[0-9\-.]+/
        return !!(re =~ line)
      end
    end
  end
end
