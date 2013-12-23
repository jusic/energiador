Energiador
==========

Simple energy draw meter for the Jolla phone / SailfishOS. It is currently 
a very crude hack, that just displays current energy draw. It does not
work on the Sailfish SDK emulator since the paths are different.

The aim is to add graphing into the app. Contributions are welcome.


License
-------

The code (including scripts) is placed under MIT license by Jussi Sainio.


Notes
-----

QtBatteryInfo_ can be used to view the same information, but this comes over
DBus at irregular intervals at least in SailfishOS 1.0.1.12 (Laadunjärvi),
and current draw just shows 0 mA for most of the time. (See QtSystemInfo `qml-battery example`_)

.. _QtBatteryInfo: http://doc.qt.digia.com/qtmobility-1.2/qml-batteryinfo.html#details
.. _`qml-battery example`: https://qt.gitorious.org/qt/qtsystems/source/f632aee809fed2e96c7f4ed598ed7615a008d9b1:examples/systeminfo/qml-battery

It is possible to use command "upower -d" to figure out the correct paths
for the energy sensors both on the Jolla phone and Sailfish SDK emulator.

By installing Python on the phone, it is simple to write a Python script
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

This produces a plot of the energy consumption over time. There are some
issues when the device is idle; the Python interpreter seems to stall at
some point (maybe time.sleep?).

.. image:: https://github.com/jusic/energiador/master/pics/script_plot_1_0_1_12.png

This example picture is produced by the above-mentioned script, running
in ``screen`` on Jolla phone running SailfishOS 1.0.1.12. The other half daemon
(known to have `a bad power drain problem`_ in this version) was turned off 
with ``systemctl stop tohd.service``.

.. _`a bad power drain problem`: http://www.jollatides.com/2013/12/23/source-of-battery-drain-nfc-always-on-solution/
