# BER-testing, by Alex Yazdani
Cisco secure shell script to test BER of a setup of an optical port.   Will only work for CAT-9k devices.  

To use this to measure BER, simply copy and paste the code in full into the Cisco CLI.  The Rx of the module under test must be receiving a PRBS-31 signal.  
After setting up and entering code, user can type "rxtest <interface>" and will then be prompted to enter a runtime in minutes.  knowing the runtime and number of errors, as well as the data rate, BER can be easily calculated.
