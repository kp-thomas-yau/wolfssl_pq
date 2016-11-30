#!/bin/sh
# Creates the coverage output for the library.
# Runs the tests for the current configuration.
# Must be run on Linux and have lcov installed.
# The configuration must have used --enable-coverage.
#

COVERAGE_HTML=../coverage
COVERAGE_INFO=../coverage.info

which lcov >/dev/null 2>&1
LCOV=$?
which genhtml >/dev/null 2>&1
GENHTML=$?
if [ $LCOV -ne 0 -o $GENHTML -ne 0 ]; then
  echo 'Please install lcov on this system.'
  echo
  return 1
fi

grep -- '--enable-coverage' config.status >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'Not configured for coverage!'
  echo
  echo 'Configure with option:\n  --enable-coverage'
  echo
  return 1
fi

if [ ! -d "$COVERAGE_HTML" ]; then
  mkdir $COVERAGE_HTML
fi

make clean
make test

lcov --capture --directory . --output-file $COVERAGE_INFO

genhtml $COVERAGE_INFO --output-directory $COVERAGE_HTML

OUTDIR=`readlink -m $PWD/$COVERAGE_HTML`
echo
echo 'Coverage results:'
echo "  $OUTDIR/index.html"
echo

