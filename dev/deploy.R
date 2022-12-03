# deploy app

# if deploying in vs code container, must create /workspaces/rsconnect dir first
# sudo mkdir /workspaces/rsconnect
# sudo chown -R eric:eric /workspaces/rsconnect

# one-time operation
rsconnect::setAccountInfo(
    name = "rpodcast",
    token = Sys.getenv("RSCONNECT_TOKEN"),
    secret = Sys.getenv("RSCONNECT_SECRET")
)


rsconnect::deployApp(
  appName = "dynamicui",
  launch.browser = FALSE, 
  forceUpdate = TRUE
)