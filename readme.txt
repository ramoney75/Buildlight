Follow these instructions to get your Delcom build light working.


1. Unzip the distribution

2. Plug in your build light

3. The New Hardware wizard should appear. Point it at the driver '<install dir>/driver/USBDELVI.sys'.  This should install successfully.

4. Install Ruby (if you haven't already). The Windows One-click installer can be found here (http://rubyforge.org/frs/?group_id=167) .

5.  To manually control your build light simply double click the light_*.rb files.
or use the following command:  ruby set_light.rb <success|fail|building|reset> 

6. For Cruise integration run build_light_server.rb (you can double click .rb files in Explorer or use the command line).  This will start build light server listening on port 1555.

7. In your CruiseControl project simply add the the following to your config.xml in the project you wish to monitor:
 
<publishers>
	<socket socketServer="<pc name where the light is plugged in>" port="1555" />
</publishers>


Enjoy!


Any problems, feedback or suggestions, please let me know.


Josh Price
ThoughtWorks  |  Level 7  16 O'Connell Street  Sydney
m: +61 415 366 251  |  yahooID: joshcprice