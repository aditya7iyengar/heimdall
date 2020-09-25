#!/bin/bash

failures=0

for i in {1..10}
do
  echo "Running the test: $i/10 times"
  echo "Number of failures: $failures"

  ./browser-test-runner.sh

  if [ $? -ne 0 ]; then
    ++$failures
  fi

  sudo fuser -k 4010/tcp
done
