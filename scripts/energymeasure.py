import subprocess
import time

while True:
	with \
		open("/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/current_now") as c,\
		 open("/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/voltage_now") as v:
		print "%s;%s;%s" % (time.time(), float(c.read()), float(v.read()))

	time.sleep(0.5)
