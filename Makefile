BREW_CORE ?= resources/brew.core.sh
BREW_DEV ?= resources/brew.dev.sh
BREW_CUSTOM ?= resources/brew.custom.sh

CONFIG_DEFAULTS ?= resources/config.macos.sh
CONFIG_SECURITY ?= resources/config.security.sh

# Install core and dev utils
brew: core dev

# Install core utils with homebrew
core:
	bash $(BREW_CORE)

# Install dev tools
dev:
	bash $(BREW_DEV)

# Personalized/custom brew packages
custom:
	bash $(BREW_CUSTOM)

# Configure macos defaults
defaults:
	bash $(CONFIG_DEFAULTS)

# Configure macos security
security:
	bash $(CONFIG_SECURITY)