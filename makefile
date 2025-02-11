.PHONY: all clean pdf site

# Build everything
all: pdf site

# Build the Jekyll site
site:
	bundle exec jekyll build

# Generate PDFs
pdf:
	$(MAKE) -C arsenale/metafisica pdf
	$(MAKE) -C arsenale/pto pdf

# Clean everything
clean:
	$(MAKE) -C arsenale/metafisica clean
	$(MAKE) -C arsenale/pto clean
	rm -rf _site
