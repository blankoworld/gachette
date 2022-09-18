# First stage to compile application
FROM crystallang/crystal:1.5-alpine AS build

WORKDIR /app

# Only copy dependencies if necessary
COPY ./shard.yml ./shard.lock /app/
RUN shards install --production -v

# Copy the entire project and build it
COPY . /app/
RUN shards build --static --no-debug --release --production -v

# Second stage to use result as a single layer image
FROM scratch
ENV KEMAL_ENV=production
COPY --from=build /app/bin/gachette /bin/gachette
COPY gachette.ini.example /etc/gachette.ini
WORKDIR /opt
COPY public/ /opt/public/
ENTRYPOINT ["/bin/gachette", "-c", "/etc/gachette.ini"]
#CMD ["--help"]
EXPOSE 3000
