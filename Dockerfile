# Pterodactyl Panel on Railway: the official image, unchanged, plus a start step that creates the
# first admin from template variables. Upstream's entrypoint still runs first (it waits for the
# database, migrates, starts cron) and then execs this image's CMD.
FROM ghcr.io/pterodactyl/panel:v1.15.2
COPY railway-start.sh /railway-start.sh
CMD ["/bin/ash", "/railway-start.sh"]
