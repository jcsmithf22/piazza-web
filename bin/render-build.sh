#!/usr/bin/env bash

# exit on error
set -o errexit

./bin/bundle install
./bin/rails assets:precompile
./bin/rails assets:clean
./bin/rails db:migrate