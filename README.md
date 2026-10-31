# Deploy and Host Pterodactyl Panel on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/pterodactyl-server-panel?referralCode=sLjDXb&utm_medium=integration&utm_source=button&utm_campaign=pterodactyl-server-panel)

[Pterodactyl](https://pterodactyl.io) is the open-source control panel for game servers: Minecraft (Paper, Forge, Vanilla, Bungeecord), Rust, ARK, Team Fortress 2, Garry's Mod, TeamSpeak and more, each in its own isolated container. The panel is where you and your players create servers, open the console, manage files, schedule restarts and backups, and hand out sub-user access. This template runs the official panel image, version-pinned, with MariaDB and Redis, and creates your admin account on first boot.

## About Hosting Pterodactyl Panel

Pterodactyl has two parts. The **Panel** (this template) is the web app and API. **Wings** is the daemon that actually runs game servers, and it needs a Docker host of its own: a VPS or a dedicated machine. Railway hosts the panel; Wings runs on your machine and connects back to it.

Three services:

- **Panel**: the official `ghcr.io/pterodactyl/panel` image (1.15.2). On every boot it waits for the database and runs migrations; on the first boot it also creates the admin from `ADMIN_EMAIL`, `ADMIN_USERNAME` and `ADMIN_PASSWORD`. Its volume keeps the generated settings.
- **MariaDB**: users, servers, nodes and eggs, on a volume.
- **Redis**: cache, sessions and the job queue.

The panel trusts Railway's proxy, so it sees HTTPS and real client addresses, and sends its logs to Railway's log view.

## Common Use Cases

- Host Minecraft servers for friends or a community, with a web console and file manager
- Run a small game hosting business with users, sub-users and per-server limits
- Manage several game machines (Wings nodes) from one panel
- Give players a self-service way to restart, back up and update their servers

## Dependencies for Pterodactyl Panel Hosting

- An email address for the admin account
- For running game servers: a Linux machine with Docker for Wings (any VPS works)

### Deployment Dependencies

- [Pterodactyl documentation](https://pterodactyl.io/project/introduction.html)
- [Installing Wings](https://pterodactyl.io/wings/1.0/installing.html)
- [Panel on GitHub](https://github.com/pterodactyl/panel)
- [Template source](https://github.com/two-workspaces/pterodactyl)

### Implementation Details

**First login:**

1. Enter your email as `ADMIN_EMAIL` when you deploy.
2. When the Panel service is up (the first boot seeds the database, under a minute), open its Railway domain.
3. Log in with `ADMIN_USERNAME` (default `admin`) and the generated `ADMIN_PASSWORD` from the Panel's Variables tab, then change the password under Account.

**Connecting a Wings node:**

1. In the panel, go to **Admin → Locations** and create one.
2. **Admin → Nodes → Create New**: the FQDN is your game machine's domain or IP, with SSL on if Wings will have a certificate.
3. On the machine, [install Docker and Wings](https://pterodactyl.io/wings/1.0/installing.html), then paste the config from the node's **Configuration** tab into `/etc/pterodactyl/config.yml` and start Wings.
4. Add allocations (IP and ports) to the node, and create your first server under **Admin → Servers**.

Wings calls the panel at `APP_URL`, which is your Railway domain over HTTPS. After adding a custom domain, set `APP_URL` to it and update the node configs.

**Settings:**

- Email: set up SMTP under **Admin → Settings → Mail**. Until then `MAIL_MAILER=log` writes emails to the log instead of sending them.
- `APP_TIMEZONE` sets the time used for schedules.
- `APP_KEY` encrypts node tokens and other secrets, and `HASHIDS_SALT` makes the short server ids. Both are generated at deploy. Never change them afterwards.

Notes and limits:

- Game servers do not run on Railway; the panel alone shows nodes and servers but starts nothing until a Wings node is connected.
- Login uses Pterodactyl's built-in reCAPTCHA. To use your own keys or turn it off, go to **Admin → Settings → Advanced**.
- Redis keeps no data on disk. A Redis restart signs everyone out and drops queued jobs; nothing in the database is lost.

## Why Deploy Pterodactyl Panel on Railway?

Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Pterodactyl Panel on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
