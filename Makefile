.DEFAULT_GOAL := default

# Return makefile directory path.
CWD := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

# Docker image providing static analysis tools for PHP.
IMAGE_NAME := 'jakzal/phpqa'
IMAGE_TAG := 'php7.4-alpine'

# YAML-LINT. A compact command line utility for checking YAML file syntax. (https://github.com/j13k/yaml-lint)
yaml-lint:
	$(call run, find -regex '\(.*yaml\|.*yml\)' -print0 | xargs -0 yaml-lint)

# PHP CodeSniffer. Detects coding standard violations. (https://github.com/squizlabs/PHP_CodeSniffer)
phpcs:
	$(call run, phpcs --extensions=php --standard=PSR12 src)

# PHP CodeSniffer. Automatically correct coding standard violations. (https://github.com/squizlabs/PHP_CodeSniffer)
phpcbf:
	$(call run, phpcbf src)

# PHP Copy/Paste Detector. Detect duplications of code. (https://github.com/sebastianbergmann/phpcpd)
phpcpd:
	$(call run, phpcpd src)

# PHP Mess Detector. A tool for finding problems in PHP code. (https://phpmd.org/)
phpmd:
	$(call run, phpmd src ansi cleancode,codesize,controversial,design,naming,unusedcode)

# PHPLOC. Measuring the size and analyzing the structure of a PHP project. (https://github.com/sebastianbergmann/phploc)
phploc:
	$(call run, phploc src)

# PHPStan. Finding errors in your code without actually running it. (https://github.com/phpstan/phpstan)
phpstan:
	$(call run, phpstan analyse --level 5 src)

# PHPUnit. Running unit tests. (https://github.com/sebastianbergmann/phpunit)
phpunit:
	$(call run, phpunit-7 tests --bootstrap vendor/autoload.php)

default: yaml-lint phpcs phpcpd phpmd phpstan phpunit

define run
    docker run -it --rm --volume $(CWD):/project --workdir /project $(IMAGE_NAME):$(IMAGE_TAG) /bin/ash -c "$(1)"
endef
