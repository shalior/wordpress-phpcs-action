## PHP Code Sniffer GitHub action
### Run and fix errors

[![release](https://github.com/shalior/wordpress-phpcs-action/workflows/release/badge.svg)](https://github.com/shalior/action-phpcs-wordpress/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/shalior/wordpress-phpcs-action?logo=github&sort=semver)](https://github.com/shalior/action-phpcs-wordpress/releases)

- **Works on every PHP code base**, including **WordPress**(all rules are bundled).
- Supports configuration files (`phpcs.xml`, `phpcs.xml.dist`, ...).
- Fixes all fixable errors.

This action runs PHPCS and fix errors using PHPCBF. If the errors are not fixable the job will fail, if they are phpcbf will fix them.
The WordPress rulesets are bundled and made available to `phpcs`. The action supports using PHPCS configuration files if there is a `phpcs.xml` or other supported file names.

## Input

```yaml
inputs:
  github_token:
    description: 'GITHUB_TOKEN'
    default: '${{ github.token }}'
  workdir:
    description: 'Working directory relative to the root directory.'
    default: '.'
  ### Flags for phpcs-wordpress ###
  phpcs_args:
    description: 'Additional PHPCS flags'
    default: '.'
  phpcbf_args:
    description: 'Additional PHPCBF flags'
    default: '.'
  phpcs_standard:
    description: 'Coding standard for PHPCS to use when checking files'
    default: 'WordPress'
  use_default_configuration_file:
    description: 'Whether to use default configuration file(phpcs.xml) or not'
    default: 'true'
```

## Usage

```yaml
name: WPCS checker
on: push
jobs:
  linter_name:
    name: runner / phpcs
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: shalior/wordpress-phpcs-action@master
        with:
          github_token: ${{ secrets.github_token }}
          use_default_configuration_file: true
          phpcs_args: '-n' # ignore warnings
      - uses: stefanzweifel/git-auto-commit-action@v4 # auto commit the fixes action for GitHub
        with:
          commit_message: Fix PHPCS errors
```

### PHPCS Coding Standards

The following sniffs are currently available. You can configure the standard(s) used by using the `phpcs_standard` input setting. By default, `WordPress` is used.

- MySource
- PEAR
- PHPCompatibility: `9.3.5`
- PHPCompatibilityWP: `2.1.5`
- PSR1
- PSR12
- PSR2
- Squiz
- WordPress: `3.1.0` 
- WordPress-Core: `3.1.0` 
- Wordpress-Docs: `3.1.0` 
- WordPress-Extra: `3.1.0` 
- WordPress-VIP-Go: `3.0.1`
- WordPressVIPMinimum: `3.0.1`
- Zend
- (Soon) WooCommerce


This action is based on [action-phpcs-wordpress](https://github.com/oohnoitz/action-phpcs-wordpress).