# Postfix + OpenSearch Logging Infrastructure

To repozytorium zawiera kompletny Proof of Concept infrastruktury do analizy logów mailowych z Postfixa w czasie rzeczywistym za pomocą OpenSearch i Filebeat.

## Moduły

- `terraform/` – Provisioning dwóch instancji EC2 (mail-server + opensearch) wraz z security groupami
- `mail-server/` – Serwer pocztowy (Postfix + Dovecot) + Filebeat + Logstash
- `opensearch/` – OpenSearch + Dashboards (via Docker Compose)

## Założenia

- Postfix i Dovecot są zainstalowane na jednej maszynie EC2
- Druga instancja EC2 uruchamia OpenSearch i Dashboards w kontenerach
- Filebeat zbiera logi z `/var/log/maillog` i przesyła je do lokalnego Logstasha
- Logstash wysyła dane do OpenSearch (drugi serwer)

## Szybki start

1. Uruchom infrastrukturę (EC2) z katalogu `terraform/`
2. Skonfiguruj serwer `opensearch/` (docker-compose + certyfikaty)
3. Skonfiguruj serwer `mail-server/` (Postfix + Dovecot + Filebeat + Logstash)
4. Otwórz `OpenSearch Dashboards` i dodaj index pattern np. `filebeat-*`

## Foldery

| Folder         | Opis                                                                 |
|----------------|----------------------------------------------------------------------|
| `terraform/`   | Provisioning EC2 + przypisanie Elastic IP + SG                        |
| `opensearch/`  | Kontenery z OpenSearch i Dashboards + certyfikaty                    |
| `mail-server/` | Serwer pocztowy + logowanie + forwarding logów do OpenSearch         |


---

## 📸 Demo działania (PoC)

Zobacz przykładowy przepływ wiadomości przychodzących i wychodzących, wraz z podglądem logów w OpenSearch:

👉 [DEMO.md – mail flow z logowaniem w OpenSearch](DEMO.md)

## Autor -  Emil Kowalczyk "CloudManiak".
Projekt został zrealizowany w celu sprawdzenia działania stacku logującego Postfix + Dovecot z forwardingiem logów do OpenSearch, jako alternatywy dla starszych wersji ElasticSearch wdrożonych np. w Wazuh. W odróżnieniu od komercyjnego ElasticSearch, OpenSearch pozostaje w pełni open-source, co pozwala na większą elastyczność i brak ograniczeń licencyjnych.