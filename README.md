#Translation Examples
##Batch Processing
################################################################################
__NOTE__
This is one of the many ways to leverage the java library (agmip-core) inside a
scripting environment. The translators are currently implemented using jruby,
but will be converted to pure java for others to be able to implement them.

Also note, the .jar file may be compiled for your computer by downloading
agmip-core and running `mvn package` (uses Maven)

##Requirements

* jruby
* java
* (Optional) RVM
* (Optional) Maven


##Usage
1. Dump .AgMIP files into the input directory
2. `ruby batch_process.rb`
3. Retrieve converted files from the output directory
