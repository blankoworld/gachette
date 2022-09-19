build: bin
	crystal build src/gachette.cr -o bin/gachette --release --stats

production: bin
	docker build -t gachette:prod_generation .
	docker run -it -d --name gachette_production -P gachette:prod_generation
	docker cp `docker ps -aqf "name=gachette_production"`:/bin/gachette ./gachette.production
	docker stop gachette_production && docker rm gachette_production

bin:
	mkdir -p bin

clean:
	rm -rf bin docs

doc docs:
	crystal docs

test tests:
	KEMAL_ENV=test crystal spec
