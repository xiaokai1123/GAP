#!/bin/sh

./eeupdate64e /NIC=1 /FILE=I210_Invm_Copper_APM_v0.6.txt /MAC=E05A9FB02C01 /INVMUPDATE
sleep 1
./eeupdate64e /NIC=1 /INVMVERIFY /FILE=I210_Invm_Copper_APM_v0.6.txt

./eeupdate64e /NIC=2 /FILE=I210_Invm_Copper_APM_v0.6.txt /MAC=E05A9FB02C02 /INVMUPDATE
sleep 1
./eeupdate64e /NIC=2 /INVMVERIFY /FILE=I210_Invm_Copper_APM_v0.6.txt

./eeupdate64e /NIC=3 /FILE=I210_Invm_Copper_APM_v0.6.txt /MAC=E05A9FB02C03 /INVMUPDATE
sleep 1
./eeupdate64e /NIC=3 /INVMVERIFY /FILE=I210_Invm_Copper_APM_v0.6.txt