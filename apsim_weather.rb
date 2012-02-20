require 'java'
Dir['lib/*.jar'].each { |j| require j}
require 'date'

module AgMIP
  module Translators
    class ApsimWeather
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
        puts "Reading file " + file + "[APSIM]"
        puts "NOT YET IMPLEMENTED!!!"
      end

      def writeFile(file)
        puts "Writing file " + file + "[APSIM]"
        loc_info = @location.get_location.get_location
        fh = File.open(file, 'w')
        if (title = @location.get_extra_data["location_detail"])
          fh.puts "!title: "+@location.get_extra_data["location_detail"]+"\r\n"
        end
        fh.print "!NOTE: This is minimal data until a list of met variables\r\n"
        fh.print "!      is obtained (cvillalobos@ufl.edu)\r\n"
        fh.print "!NOTE: The user should run TAV_AMP on these files\r\n"
        fh.print "[weather.met.weather]\r\n"
        fh.printf("latitude = %.2f (DECIMAL DEGREES)\r\n", loc_info.get_lat)
        fh.printf("longitude = %.2f (DECIMAL DEGREES)\r\n", loc_info.get_lon)
        fh.printf("tav = %.2f (oC)\r\n", @location.get_temp_average)
        fh.printf("amp = %.2f (oC)\r\n\r\n", @location.get_temp_amplitude)
        fh.print "year  day  radn    maxt  mint  rain  wind  dewp  vers  rh\r\n"
        fh.print "()    ()   (MJ/m2) (oC)  (oC)  (mm)  (km)  (oC)   ()   (%)"
                 #         111111111122222222223333333333444444444455555555556
                 #123456789012345678901234567890123456789012345678901234567890
        @data.each { |v|
          d = v.getRawData
          fh.printf("\r\n%4d  %-3d  %-6.1f  %-5.1f %-5.1f %-5.1f %-5.1f %-5.1f %-5.1f %-3d",
                    d["date"].year,
                    d["date"].yday,
                    d["srad"],
                    d["tmax"],
                    d["tmin"],
                    d["rain"],
                    d["wind"],
                    d["dewp"],
                    d["vprs"],
                    d["rhum"])
        }
        fh.close
      end
    end
  end
end
