##
# This script is a simple chaining of converting files from .AgMIP to
# other file formats
#
# Converted 128 Files into all three formats (128*3 files)
require 'agmip_weather'
require 'dssat_weather'
require 'apsim_weather'
require 'stics_weather'

files  = Dir.glob("input/*.AgMIP")
apsim = AgMIP::Translators::ApsimWeather.new
dssat = AgMIP::Translators::DssatWeather.new
stics = AgMIP::Translators::SticsWeather.new
#models = [apsim, dssat, stics]
models = [dssat]
files.each { |file|
  output = './output/'+File.basename(file, ".AgMIP")
  source = AgMIP::Translators::AgmipWeather.new
  source.readFile(file)
  models.each { |m|
    m.writeFile(output, source.location, source.data)
  }
}
