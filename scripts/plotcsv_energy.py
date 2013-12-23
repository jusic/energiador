#!/usr/bin/env python

#
# Plots a two-column csv file using matplotlib.
# The first row of the csv file is assumed to contain axis labels.
#

import matplotlib.pyplot as plt
import csv
import sys
import numpy as np

if len(sys.argv) <= 1:
    print "usage: %s [csv-file]" % sys.argv[0]
    quit()

t1 = []
t2 = []
y1 = []
y2 = []
with open(sys.argv[1], "rb") as f:
    reader = csv.reader(f, delimiter=";")
    for row in reader:
        if row[1] != "" and row[2] != "":
            t1.append(row[0])
            t2.append(row[0])
            y1.append(float(row[1]))
            y2.append(float(row[2]))

f, axarr = plt.subplots(3, sharex=True)
plt.grid(True)
axarr[0].plot(t1[1:], np.array(y1[1:]) / 1e3, label="current")
axarr[0].set_ylabel("current [mA]")
#plt.grid()
axarr[1].plot(t2[1:], np.array(y2[1:]) / 1e6, label="voltage")
axarr[1].set_ylabel("voltage [V]")
#plt.grid()
axarr[2].plot(t2[1:], np.array(y2[1:]) / 1e6 * np.array(y1[1:]) / 1e6, label="power")
axarr[2].set_ylabel("power [W]")
plt.xlabel("time [s]")
#plt.grid()
#plt.legend()
plt.show()
