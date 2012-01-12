require 'agmip_weather'
require 'dssat_weather'
require 'apsim_weather'

files  = Dir.glob("input/*.AgMIP")
apsim = AgMIP::Translators::ApsimWeather.new
dssat = AgMIP::Translators::DssatWeather.new

files.each { |file|
  output = './output/'+File.basename(file, ".AgMIP")
  source = AgMIP::Translators::AgmipWeather.new
  source.readFile(file)
  apsim.data = source.data
  apsim.location = source.location
  apsim.writeFile(output.downcase+".met")
  dssat.data = source.data
  dssat.location = source.location
  dssat.writeFile(output+".WTH")
  dssat.clear
  apsim.clear
}
