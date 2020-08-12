#!/bin/bash

cdwhereis() {
  OPTION=$2
  echo $OPTION
  echo $(echo $(whereis $1) | awk '{print $($OPTION)}')

#  echo $(echo $(whereis $1) | awk '{print $($2)}')

  #echo $(echo $(whereis $1) | awk '{print $2}')
  #cd $(echo $(echo $(whereis bash) | awk '{print $OPTION}'))
}
