Energiador
==========

A simple energy draw meter for the Jolla phone / SailfishOS. It is currently 
a very crude hack, that just displays current energy draw and a history
graph of max. 120 previous data points (~30s of data). 

There are some issues when the device is in standby. The QTimer which
triggers data fetching does not fire every 250ms while in standby mode, 
but much more rarely. This is probably due to 
aggressive power saving mode in Jolla / Sailfish.
(See notes below.)

Comments, ideas and contributions are welcome.


License
-------

The code (including scripts) is placed under MIT license by Jussi Sainio.


Screenshots
-----------

.. image:: pics/screenshot_0.2.png
   :height: 400
.. image:: pics/screenshot_cover_0.2.png


Notes
-----

Standby mode is still a challenge, since timers do not fire when they are
supposed to. (This affects also the Python script below.) In standby,
the main processor (CPU) spends time in alternative power saving modes 
called `C-states`_. C0 is the normal "active" mode and increasing number 
indicates more aggressive power saving mode or increasing "sleepyness".

When placed in a power saving state, the CPU may not run any application code. 
Instead, the CPU waits for interrupts (e.g. a hardware timer or a network interrupt) to wake it up and start running code again. The amount of time that 
the CPU spends in different states can be figured out through 
``cat /sys/devices/system/cpu/cpuN/cpuidle/CM/time``, 
where N is the cpu core and M the C-state. 
The return values are in microseconds spent in the respective C-state. Alternatively,
PowerTOP shows this information as well, and it can be installed with `these instructions`_.

.. _`C-states`: http://harmattan-dev.nokia.com/docs/library/html/guide/html/Developer_Library_Developing_for_Harmattan_Developer_tools_Performance_testing_tools_Using_PowerTOP.html
.. _`these instructions`: http://talk.maemo.org/showthread.php?t=92036

It is possible to use command ``upower -d`` to figure out the correct sysfs paths
for the energy sensors both on the Jolla phone and Sailfish SDK emulator.
On the device, the power information can be directly read from sysfs path
``/sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/``, e.g. ``current_now`` and ``voltage_now``. These are used in the current
implementation.

`UPower documentation`_ 
notes that it can control "latency of different operations", by adjusting ``/dev/cpu_dma_latency``, ``/dev/network_latency`` and 
``/dev/network_throughput``. At least the ``/dev/cpu_dma_latency`` value changes
between 3us, 200us and 2000s (sic!). The `upowerd`` should publish a 
`QoS DBus interface`_ for adjusting these values, but I did not manage to 
get it working on Sailfish yet. Nor have I found a way to set up a hardware 
timer nicely. There exists a `QSystemAlignedTimer`_ class which uses 
`libiphb`_ heartbeat library/service (originally from Meego). However, these provide 
only second interval resolution at minimum.

.. _`UPower documentation`: http://upower.freedesktop.org/
.. _`QoS DBus interface`: http://upower.freedesktop.org/docs/QoS.html
.. _`QSystemAlignedTimer`: http://doc.qt.digia.com/qtmobility/qsystemalignedtimer.html
.. _`libiphb`: https://github.com/nemomobile/libiphb/

QtBatteryInfo_ can be also used to view the power information. The data comes over
DBus from UPower at irregular intervals at least in SailfishOS 1.0.1.12 (Laadunjärvi),
and current draw just shows 0 mA for most of the time. (See QtSystemInfo `qml-battery example`_.)

.. _QtBatteryInfo: http://doc.qt.digia.com/qtmobility-1.2/qml-batteryinfo.html#details
.. _`qml-battery example`: https://qt.gitorious.org/qt/qtsystems/source/f632aee809fed2e96c7f4ed598ed7615a008d9b1:examples/systeminfo/qml-battery



I want power history logs now!
------------------------------

Ok, the app is not there yet, but it is simple enough to write a Python script
for collecting data over time and graphing it later. A sample script
is provided under ``/scripts/energymeasure.py``.

Just enable Developer mode on the phone, move the script on the phone 
(e.g. using scp) and run 
  
  ::

  $ pkcon install python
  $ python energymeasure.py > log.csv

Then, move the log.txt to a computer with python + numpy + matplotlib installed,
and run

  ::

  $ python plotcsv_energy log.csv

This produces a plot of the energy consumption over time. 

.. image:: pics/script_plot_1_0_1_12.png

This example picture is produced by the above-mentioned script, running
in ``screen`` on Jolla phone running SailfishOS 1.0.1.12. The other half daemon
(known to have `a power drain problem`_ in this version) was turned off 
with ``systemctl stop tohd.service``.

.. _`a power drain problem`: http://www.jollatides.com/2013/12/23/source-of-battery-drain-nfc-always-on-solution/
