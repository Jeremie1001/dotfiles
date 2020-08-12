#!/bin/bash

kernel () {
  OUTPUT=$(uname -srm)
  echo "Current Kernel: ${OUTPUT}"
}
