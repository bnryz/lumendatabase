FROM docker.io/library/logstash:7.17.0

# Download PostgreSQL JDBC for Logstash
ADD --chown=1000 "https://jdbc.postgresql.org/download/postgresql-42.6.0.jar" /usr/share/logstash/bin/postgresql-42.6.0.jar
COPY . /srv
CMD ["logstash", "--path.settings", "/srv"]
