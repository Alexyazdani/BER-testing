# BER-testing, by Alex Yazdani
Cisco secure shell script to test BER of a setup of an optical port.   Will only work for CAT-9k devices.  

To use this to measure BER, simply copy and paste the code in full into the Cisco CLI.  The Rx of the module under test must be receiving a PRBS-31 signal.  
After setting up and entering code, user can type "rxtest (interface)" and will then be prompted to enter a runtime in minutes.  The port's interface number can be found using "show platform software fed switch active ifm mappings" 

Knowing the runtime and number of errors, as well as the data rate, BER can be easily calculated.
  
The commands at the beginning disable the exec timeout, preventing it from interrupting the test.  Exec timeout can be set by changing the "exec-timeout 0 0" lines to "exec-timeout (minutes) (seconds)"

Update 10/13/2022:  Function now exits if number of errors is too high.  Useful because the sleep function of the IOS.sh shell does not allow escaping with ctrl-c.  Also will tell user the usage if improper input is given.
