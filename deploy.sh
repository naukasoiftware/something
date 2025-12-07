#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=${1:-/home/user/sites}
REMOTE=${2:-user@server}
REMOTE_ROOT=${3:-/home/user/sites}

printf "\n==> Syncing static sites to %s:%s\n" "$REMOTE" "$REMOTE_ROOT"
rsync -avz --delete sites/ "$REMOTE:$REMOTE_ROOT/"

printf "\n==> Setting permissions (755 dirs, 644 files)\n"
ssh "$REMOTE" "find $REMOTE_ROOT -type d -exec chmod 755 {} + && find $REMOTE_ROOT -type f -exec chmod 644 {} +"

printf "\n==> Placing Apache vhost file\n"
scp apache/klasyka.conf "$REMOTE:/etc/apache2/sites-available/klasyka.conf"

ssh "$REMOTE" <<'CMDS'
sudo a2dissite 000-default.conf
sudo a2ensite klasyka.conf
sudo systemctl reload apache2
CMDS

cat <<'HINT'
Opcjonalnie wygeneruj certyfikaty Let's Encrypt dla każdej domeny:
  sudo certbot --apache -d paznokciebrwinow.pl -d www.paznokciebrwinow.pl \
               -d paznokcieparzniew.pl -d www.paznokcieparzniew.pl \
               -d paznokciepodkowalesna.pl -d www.paznokciepodkowalesna.pl \
               -d paznokciezolwin.pl -d www.paznokciezolwin.pl \
               -d paznokciemilanowek.pl -d www.paznokciemilanowek.pl \
               -d paznokcieotrebusy.pl -d www.paznokcieotrebusy.pl \
               -d manicurebrwinow.pl -d www.manicurebrwinow.pl \
               -d klasykabrwinow.com.pl -d www.klasykabrwinow.com.pl
Jeśli SSL dostarcza Cloudflare, pomiń certbot i upewnij się, że włączona jest opcja „Always Use HTTPS”.

Opcjonalnie: wyczyść cache CDN po wdrożeniu (np. Cloudflare API purge cache).
HINT
