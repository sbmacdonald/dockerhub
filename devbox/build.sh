#!/bin/bash

cp $HOME/.bashrc bashrc
docker build --tag=sbmacdonald/devbox .
rm bashrc
