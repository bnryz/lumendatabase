FROM docker.io/library/logstash:7.17.0

# let's NOT do this permission nonsense
USER 0
# Download PostgreSQL JDBC for Logstash
ADD https://jdbc.postgresql.org/download/postgresql-42.6.0.jar /usr/share/logstash/bin/postgresql-42.6.0.jar
COPY . /srv
CMD ["logstash", "--path.settings", "/srv"]
