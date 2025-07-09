#!/bin/csh

source ~/USER/cshrc

xrun -access +rwc -uvm -f file.f +SVSEED=random -define INJECT_ERROR

#xrun -access -f +rwc -uvm run.f -define INJECT_ERROR