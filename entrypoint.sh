#!/bin/sh

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
  git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

/usr/local/bin/phpcs.phar --config-set installed_paths /tmp/rulesets

run_phpcs() {
  if [ "${INPUT_USE_DEFAULT_CONFIGURATION_FILE}" = true ]; then
    /usr/local/bin/phpcs.phar \
      "${INPUT_PHPCS_ARGS:-\.}"
  else
    /usr/local/bin/phpcs.phar \
      --standard="${INPUT_PHPCS_STANDARD}" \
      "${INPUT_PHPCS_ARGS:-\.}"
  fi
}

run_phpcbf() {
  if [ "${INPUT_USE_DEFAULT_CONFIGURATION_FILE}" = true ]; then
    /usr/local/bin/phpcbf.phar \
      "${INPUT_PHPCBF_ARGS:-\.}"
  else
    /usr/local/bin/phpcbf.phar \
      --standard="${INPUT_PHPCS_STANDARD}" \
      "${INPUT_PHPCBF_ARGS:-\.}"
  fi
}

run_phpcs

# get status code of command
# 0 = success
# phpcs 2 = fixable errors found
# phpcs 1 = only not fixable errors found

RESULT=$?
echo "exit code = ${RESULT}"
if [ "${RESULT}" -ne 0 ]; then
  echo "phpcs failed with status code: ${RESULT}"

  #if result is 1, then only not fixable errors found
  if [ "${RESULT}" -eq 1 ]; then
    echo "only not fixable errors found"
    exit 1
  fi

  #if result is 2, then fixable errors found
  if [ "${RESULT}" -eq 2 ]; then
    echo "fixable errors found (2)"
    echo "Running phpcbf"
    run_phpcbf

    # rerun phpcs
    echo "Running phpcs again"
    run_phpcs

    SECOND_PHPCS_RESULT=$?

    echo "Second phpcs result = ${SECOND_PHPCS_RESULT}"

    if [ "${SECOND_PHPCS_RESULT}" -eq 1 ]; then
      echo "phpcbf failed to fix all errors"
      exit 1
    fi

    # if second phpcs result is 0, then no errors found
    if [ "${SECOND_PHPCS_RESULT}" -eq 0 ]; then
      echo "Success, no errors found"
      exit 0
    fi

    exit "${SECOND_PHPCS_RESULT}"

  fi

fi
