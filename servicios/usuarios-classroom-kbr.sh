#!/bin/bash
for i in $(seq 3 10) ; do
	expect usuarios-classroom-kbr.exp ldapuser${i}
done
