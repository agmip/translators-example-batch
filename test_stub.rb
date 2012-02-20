require 'agmip_weather'
require 'stics_weather'

files  = Dir.glob("input/*.AgMIP")
#apsim = AgMIP::Translators::ApsimWeather.new
#dssat = AgMIP::Translators::DssatWeather.new
stics  = AgMIP::Translators::SticsWeather.new

files.each { |file|
  output = './output/'+File.basename(file, ".AgMIP")
  source = AgMIP::Translators::AgmipWeather.new
  source.readFile(file)
  stics.data = source.data
  stics.location = source.location
  stics.writeFile(output+".txt")
  stics.clear
}
