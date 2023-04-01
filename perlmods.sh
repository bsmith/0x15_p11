#!/bin/sh

set -e -x

cpanm -L extlib local::lib
cpanm -L extlib Crypt::HSM Data::Dump
