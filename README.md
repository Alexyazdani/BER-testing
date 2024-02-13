# BER-testing, by Alex Yazdani
Cisco IOS shell script to test BER of a setup of an optical port.   Will work for any IOS-XE devices, unless prbs commands require attaching to a location or dropping into a shell. 

To use this to measure BER, simply copy and paste the code in full into the Cisco CLI.  The Rx of the module under test must be receiving a PRBS-31 signal.  

After setting up and entering code, user can type "prbstest <port> <time>".  Port mapping information can be found using "show platform software fed switch active ifm mappings"

The first six functions defined will likely need to be changed depending on which platform is being tested.  This particular code is designed for Catalyst 8300 series.  However, if the first six functions are changed to be compliant with desired platform, the main function (prbstest) will always work.
  
The commands at the beginning disable the exec timeout, preventing it from interrupting the test.  Exec timeout can be set by changing the "exec-timeout 0 0" lines to "exec-timeout (minutes) (seconds)"  Also, the "term shell" command allows for guest shell functionality.

The ending "wr" command will commit all changes.
  
The current version assumes that the error count clears every time errors are checked, so the variable 'errbit' is used as a counter to keep a running total.  If errors are not cleared on another platform, the prbstest function can be simplified.

Update 10/13/2022:  Function now exits if number of errors is too high.  Useful because the sleep function of the IOS.sh shell does not allow escaping with ctrl-c.  Also will tell user the usage if improper input is given.

Official Documentation: https://www.cisco.com/c/en/us/td/docs/ios/netmgmt/configuration/guide/Convert/IOS_Shell/nm_ios_shell.html
