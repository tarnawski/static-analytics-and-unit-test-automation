.DEFAULT_GOAL := default

# Returns makefile directory path.
CWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Docker image providing static analysis tools for PHP.
IMAGE_NAME := 'jakzal/phpqa'
IMAGE_TAG := 'php7.4-alpine'

yaml:
	$(call run, yaml-lint $(shell find -regex '\(.*yaml\|.*yml\)'))

# PHP CodeSniffer. Detects coding standard violations. (https://github.com/squizlabs/PHP_CodeSniffer)
phpcs:
	$(call run, phpcs --extensions=php --standard=PSR12 src)

# PHP CodeSniffer. Automatically correct coding standard violations. (https://github.com/squizlabs/PHP_CodeSniffer)
phpcbf:
	$(call run, phpcbf src)

# PHP Copy/Paste Detector. Detect duplications of code. (https://github.com/sebastianbergmann/phpcpd)
phpcpd:
	$(call run, phpcpd src)

# PHPLOC. Measuring the size and analyzing the structure of a PHP project. (https://github.com/sebastianbergmann/phploc)
phploc:
	$(call run, phploc src)

# PHPStan. Finding errors in your code without actually running it. (https://github.com/phpstan/phpstan)
phpstan:
	$(call run, phpstan analyse --level 5 src)

# PHPUnit. Running unit tests. (https://github.com/sebastianbergmann/phpunit)
phpunit:
	$(call run, phpunit-7 tests --bootstrap vendor/autoload.php)

default: yaml phpcs phpcpd phpstan phpunit

define run
    docker run -it --rm --volume $(CWD):/project --workdir /project $(IMAGE_NAME):$(IMAGE_TAG) $(1)
endef
