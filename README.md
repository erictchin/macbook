# macbook (simplified)

A simple bash-based macbook provisioning script

### Bootstrap
```bash
git clone git@github.com:erictchin/macbook.git
cd macbook

# Install xcode command line tools and homebrew
./setup.sh
```

### Review and install programs

Review each of the files listed below for your preferences.

File | Description | Install
---- | ----------- | -------
`resources/brew.core.sh` | `brew install` tools generally common to developers | `make core`
`resources/brew.dev.sh` | `brew install` typical developer tools | `make dev`
`resources/brew.custom.sh` | `brew install` packages of your choosing | `make custom`
`resources/config.macos.sh` | Configure macos with better defaults | `make defaults`
`resources/config.security.sh` | Improve macos operating system security configurations | `make security`

