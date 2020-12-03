#!/bin/bash
set -euo pipefail

DIRNAME=$1
base="2020/$DIRNAME"
mkdir "$base"

# Set up files for solutions input and script
touch "$base/solve"
cp solution-template.rb "$base/solution.rb"
