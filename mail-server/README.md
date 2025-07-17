# Mail Server Stack (Postfix + Dovecot + Filebeat + Logstash)

Ten folder zawiera kompletną konfigurację serwera pocztowego z usługami:

- Postfix – serwer SMTP
- Dovecot – serwer IMAP/POP3
- Filebeat – zbieranie logów pocztowych
- Logstash – parsowanie logów i wysyłka do OpenSearch

## Struktura folderu

mail-server/
├── config/
│   ├── filebeat.yml        # Konfiguracja Filebeat
│   ├── logstash.conf       # Konfiguracja Logstash (output -> OpenSearch)
│   └── dovecot.conf        # Ewentualne override'y do Dovecota (opcjonalne)
├── docker-compose.yml      # Definicja usług (Postfix, Dovecot, Logstash)
├── env.template            # Wzór pliku .env z danymi dostępowymi
├── setup_mail_server.sh    # Skrypt uruchamiający stack + Filebeat
├── .gitignore              # Ignoruje certyfikaty i pliki środowiskowe

## Wymagania

- EC2 z Amazon Linux 2 (lub inny z rootem)
- Docker + Docker Compose (instalowane automatycznie przez skrypt)
- Dostęp do OpenSearch (np. drugi serwer, docker-compose w folderze opensearch/)

## Instrukcja uruchomienia

1. Zaloguj się na serwerze mailowym:

   ssh ec2-user@<YOUR_MAIL_SERVER_IP>

2. Sklonuj repozytorium i przejdź do folderu:

   git clone https://github.com/<twoj_user>/postfix-logs-visualization.git
   cd postfix-logs-visualization/mail-server

3. Skonfiguruj zmienne środowiskowe:

   cp env.template .env
   nano .env

   Wypełnij:
   - DOMAIN=mail.cloudmaniak.pl
   - OPENSEARCH_HOST=<ip>:9200
   - OPENSEARCH_USER=admin
   - OPENSEARCH_PASSWORD=Infra!2_25_28_06

4. Uruchom konfigurację:

   chmod +x setup_mail_server.sh
   ./setup_mail_server.sh

## Powiązane

- opensearch/ – środowisko OpenSearch + Dashboards
- terraform/ – provisioning EC2 + security groups

## Notatki

- Certyfikaty SSL do Dovecota są generowane self-signed (można podmienić).
- Filebeat i Logstash są uruchamiane lokalnie na tej samej maszynie.
- Logi /var/log/maillog są automatycznie forwardowane do OpenSearch.