#!/bin/bash

max=2

echo $@
$@
while [ $? -ne 0 ] && [ $max -gt 0 ]; do
    max=`expr $max - 1`
    echo $@
    $@
done
