# GeoIP database goes here (see docs/DEPENDENCIES.md §GeoIP database):
#   GeoLite2-Country.mmdb
#
# Fetched separately by a Nix module (requires MaxMind license key in
# ~/.config/dodona/maxmind-key — NOT committed).
# .gitignore'd.
#
# If the DB is missing, dodona builds and runs in fallback mode
# (no geo, abstract topology globe — see widgets::globe).
