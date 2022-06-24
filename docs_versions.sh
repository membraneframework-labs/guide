#!/bin/bash

for version in 3 4 5 6 7 
do
 git clone --branch v0.$version  https://github.com/membraneframework/guide.git v0.$version \
    && cd v0.$version \
    && mix local.rebar --force \
    && mix local.hex --force \
    && mix deps.get \
    && MIX_ENV=dev mix docs && mix docs 2>&1 | (! grep -q "warning:") \
    && cd ../
done

