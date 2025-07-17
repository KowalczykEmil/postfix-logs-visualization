# OpenSearch Stack
Ten folder zawiera kompletną konfigurację do uruchomienia lokalnego środowiska OpenSearch + Dashboards (Kibana).

## Zawartość

- `docker-compose.yml` – definicja usług OpenSearch i Dashboards
- `setup_opensearch_stack.sh` – skrypt instalacyjny (Docker, certyfikaty, uruchomienie stacka)
- `certs/` – katalog z certyfikatami SSL (self-signed)
- `.env.template` – szablon zmiennych środowiskowych

## Wymagania

- EC2 z Amazon Linux 2 lub inna dystrybucja z dostępem root
- Docker + Docker Compose (instalowane automatycznie)
- Plik `.env` na podstawie `.env.template`

## Instrukcja

1. Sklonuj repozytorium i przejdź do folderu `opensearch`:

```bash
git clone https://github.com/twoje-repo.git
cd opensearch
```

2. Skopiuj plik `.env.template` jako `.env` i uzupełnij:

```bash
cp .env.template .env
vi .env
```

3. Uruchom skrypt:

```bash
bash setup_opensearch_stack.sh
```

4. Wejdź na dashboard:

```
http://<twój_adres_ip>:5601
```

Login: `admin`  
Hasło: `Infra!2_25_28_06`

## Uwagi

- Certyfikaty SSL są generowane automatycznie przy pierwszym uruchomieniu
- Porty wystawione: `9200`, `9300`, `5601`
