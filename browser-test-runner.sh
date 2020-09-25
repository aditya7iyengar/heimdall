#!/bin/bash

echo "-----------------------"
echo "Starting Phoenix Server"
echo "-----------------------"

mix phx.server &

echo "------------------------------------------------------------"
echo "Waiting for phoenix server to be ready for browser testing"
echo "------------------------------------------------------------"

while ! nc -z localhost ${BIFROST_PORT}; do
  sleep 1
done

# Give 5 seconds for watchers to start their processes
sleep 5

echo "-----------------------------------------------"
echo "Phoenix server ready, now running browser tests"
echo "-----------------------------------------------"

cd browser-tests
npm run cypress:run
