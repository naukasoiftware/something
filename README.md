# KLASYKA – statyczne mini-strony (Minimal Luxury)

## Struktura
```
/sites/
  shared_assets/
    style.css
    logo.svg
  domena/
    index.html
    robots.txt
    sitemap.xml
    .htaccess
    gallery/placeholder*.svg
apache/klasyka.conf
deploy.sh
```

## Instrukcja wdrożenia (ViperHOST)
1. Skieruj DNS domen na ns1/ns2 ViperHOST (domeny zostają u rejestratora).
2. W panelu ViperHOST dodaj każdą domenę jako *addon domain* i wskaż katalog `/home/user/sites/<domena>`.
3. Wgraj katalog `sites` na serwer (SCP/rsync/FTP). Zadbaj, aby `shared_assets` było współdzielone obok folderów domen.
4. Skopiuj `apache/klasyka.conf` do `/etc/apache2/sites-available/`.
5. Wyłącz domyślny vhost i włącz nowy:
   ```bash
   sudo a2dissite 000-default.conf
   sudo a2ensite klasyka.conf
   sudo systemctl reload apache2
   ```
6. Włącz darmowe SSL (panel ViperHOST – Let’s Encrypt) lub użyj Cloudflare Universal SSL.
7. Jeśli korzystasz z certbota na VPS, uruchom przykładowe polecenie z `deploy.sh` (sekcja HINT) dla wszystkich domen.
8. Dodaj każdą domenę do Google Search Console i kliknij „Poproś o zaindeksowanie”.
9. Podmień zdjęcia w `gallery/` na JPG/PNG/WebP zachowując nazwy plików lub aktualizując `<img>` w `index.html`.
10. Edytuj styl w `sites/shared_assets/style.css`, aby zmienić akcenty (np. kolor złota) lub animacje.

## Jak zrobić własną paczkę ZIP (opcjonalnie)
- Jeśli potrzebujesz jednego archiwum, utwórz je lokalnie:
  ```bash
  zip -r klasyka_package.zip sites apache deploy.sh README.md
  ```
- Tak przygotowany plik możesz wgrać na serwer i rozpakować w katalogu domowym użytkownika.

## Skrypt `deploy.sh`
- Wywołanie: `./deploy.sh [LOCAL_ROOT=/home/user/sites] [REMOTE=user@server] [REMOTE_ROOT=/home/user/sites]`
- Kopiuje `/sites` na serwer (rsync), ustawia prawa (755 katalogi, 644 pliki), wrzuca vhost do `/etc/apache2/sites-available/klasyka.conf`, wykonuje `a2dissite 000-default.conf`, `a2ensite klasyka.conf`, `systemctl reload apache2`.
- W bloku HINT zawiera gotową komendę certbota dla wszystkich domen (opcjonalnie) i informację o SSL z Cloudflare.

## Apache
- Plik `apache/klasyka.conf` zawiera bloki VirtualHost dla wszystkich domen z `AllowOverride All` (działa .htaccess) i wyłączonym indeksowaniem.
- Domyślny komunikat „Apache is working correctly” zostaje zastąpiony przez wyłączenie 000-default.conf i skierowanie na właściwe DocumentRoot.

## SEO i treści
- Każdy `index.html` ma unikalne `<title>`, meta description, `h1`, akapity lokalne (250–600 znaków), Open Graph, JSON-LD NailSalon z `addressLocality`, `areaServed`, `sameAs` (FB/IG) i `url` ustawionym na daną domenę.
- Linki: Booksy (`https://klasyka.booksy.pl`), Facebook i Instagram.
- `robots.txt` zawiera `Allow: /` i wskazanie `sitemap.xml`.

## Jak podmienić galerie
- Zamień pliki `gallery/placeholder*.svg` na swoje zdjęcia (JPG/PNG/WebP) zachowując nazwy lub zaktualizuj ścieżki w sekcji `Galeria` w `index.html`.

## Checklista testów
- [ ] `http://domena` → 301 do `https://domena/`
- [ ] Strona nie pokazuje komunikatu „Apache is working correctly”; ładuje się właściwy DocumentRoot.
- [ ] `/robots.txt` zwraca `Allow: /` i wskazuje sitemapę.
- [ ] `/sitemap.xml` ma poprawny URL strony głównej.
- [ ] `<title>`, meta description i `h1` zawierają nazwę miasta.
- [ ] JSON-LD przechodzi walidację schema.org.
- [ ] Linki Booksy/FB/IG działają.
- [ ] Lighthouse: Performance/SEO/Best Practices ≥ 90.
- [ ] Certyfikat SSL aktywny (kłódka).
