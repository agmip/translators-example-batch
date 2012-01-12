require 'java'
require 'lib/agmip-core-1.0-SNAPSHOT.jar'
require 'date'

module AgMIP
  module Translators
    class DssatWeather
      include_package "org.agmip.core.types"
      include org.agmip.core.types.WeatherFile
      attr_accessor :data
      attr_accessor :location
      @@default_value = -99.99

      def initialize
        @data = Array.new
        @location = nil
      end

      def clear
        @data.clear
        @location = nil
      end

      def readFile(file)
        puts "Reading file " + file + "[DSSAT]"
        puts "NOT YET IMPLEMENTED!!!"
      end

      def writeFile(file)
        puts "Writing file " + file + "[DSSAT]"
        loc_info = @location.get_location
        fh = File.open(file, 'w')
        fh.print "*WEATHER DATA :"+((@location.get_extra_data["location_detail"] == nil) ? "" : (" "+@location.get_extra_data["location_detail"]))+"\r\n"
        fh.print "\r\n@ INSI      LAT     LONG  ELEV   TAV   AMP REFHT WNDHT\r\n"
        fh.printf("%6s %8.3f %8.3f %5d %5.1f %5.1f %5.1f %5.1f\r\n",
                       loc_info.get_location_id,
                       loc_info.get_location.get_lat,
                       loc_info.get_location.get_lon,
                       loc_info.get_elevation,
                       @location.get_temp_average_or(@@default_value),
                       @location.get_temp_amplitude_or(@@default_value),
                       @location.get_reference_height_or(@@default_value),
                       @location.get_wind_height_or(@@default_value))
        fh.print "@DATE  SRAD  TMAX  TMIN  RAIN  DEWP  WIND  VPRS  RHUM"
        @data.each { |v|
          d = v.getRawData
          date = d["date"]
          formatted_date = format("%2s%03d", date.year.to_s[-2,2], date.yday.to_s)
          fh.printf("\r\n%5s %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5.1f %5d",
                    formatted_date,
                    d["srad"],
                    d["tmax"],
                    d["tmin"],
                    d["rain"],
                    d["dewp"],
                    d["wind"],
                    d["vprs"],
                    d["rhum"])
        }
        fh.close
      end
    end
  end
end
