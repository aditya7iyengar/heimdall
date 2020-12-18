#!/bin/bash

failures=0

sudo fuser -k 4010/tcp
mix ecto.reset

for i in {1..10}
do
  echo "Running the test: $i/10 times"
  echo "Number of failures: $failures"

  ./browser-test-runner.sh

  if [ $? -ne 0 ]; then
    failures = $failures + 1
  fi

  sudo fuser -k 4010/tcp
  mix ecto.reset
done
