FROM ghcr.io/rocker-org/devcontainer/tidyverse:4.2

# key dependencies for utilities
RUN apt-get update -qq \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends libxt6 curl python3-pip libsodium-dev

# install chrome for shinytest2
RUN curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
RUN apt-get update -qq \
  && apt-get -y install ./tmp/chrome.deb

# install additional R packages
RUN install2.r shiny shinytest2 languageserver httpgd rsconnect

USER rstudio
