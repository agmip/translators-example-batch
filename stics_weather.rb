require 'java'
Dir['lib/*.jar'].each { |j| require j}
require 'date'

module AgMIP
  module Translators
    class SticsWeather
      include_package "org.agmip.core.types"
      include org.agmip.core.types.WeatherFile
      attr_accessor :data
      attr_accessor :location
      @@default_value = -999.9
      @@co2_level = 330.0 #temporary hardcode 20/02/2012 - CV

      def initialize
        data = Array.new
        location = nil
      end

      def clear
        data.clear
        location = nil
      end

      def readFile(file)
        puts "Reading file " + file + "[STICS]"
        puts "NOT YET IMPLEMENTED!!!"
      end

      def writeFile(file, location, data)
        file = file+'.txt'
        puts "Writing file " + file + "[STICS]"
        loc_info = location.get_location
        loc_id   = (((location.get_extra_data["location_detail"] == nil) ? loc_info.get_location_id : location.get_extra_data["location_detail"].delete(" ").partition(",")[0]).downcase)[0,7]
        fh = File.open(file, 'w')
        data.each { |v|
          d = v.getRawData
          date = d["date"]
          formatted_date = date.strftime("%Y/%m/%d")
          fh.printf("%7s %4d %2d %2d %3d %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f\r\n",
                    loc_id,
                    date.year,
                    date.month,
                    date.mday,
                    date.yday,
                    d["tmin"],
                    d["tmax"],
                    d["srad"],
                    @@default_value,#ETP
                    d["rain"],
                    d["wind"],
                    d["vprs"],
                    @@co2_level)
        }
        fh.close
      end
    end
  end
end
