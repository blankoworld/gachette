build: bin
	crystal build src/gachette.cr -o bin/gachette --release --stats

bin:
	mkdir -p bin

clean:
	rm -rf bin docs

doc docs:
	crystal docs
