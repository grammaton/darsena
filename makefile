# Directory configuration
BASE_PATH := arsenale
AVAILABLE_DIRS := $(shell find $(BASE_PATH) -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
ACTIVE_DIRS ?= $(AVAILABLE_DIRS)

# Build configuration
LATEX_TEMP := _latex_temp
PDF_OUTPUT := tipografia
CACHE_DIR := .cache

# Tools and commands
MKDIR := mkdir -p
RM := rm -rf
TOUCH := touch
JEKYLL := bundle exec jekyll

# Cache management
CACHE_FILE = $(CACHE_DIR)/$(1).cache
UPDATE_CACHE = $(TOUCH) $(call CACHE_FILE,$(1))
CHECK_CACHE = $(shell [ -f $(call CACHE_FILE,$(1)) ] && echo "1" || echo "0")

# Make sure required directories exist
$(shell $(MKDIR) $(LATEX_TEMP) $(PDF_OUTPUT) $(CACHE_DIR))

.PHONY: all clean pdf site setup status select init watch

# Build everything
all: setup site pdf

# Setup necessary directories and initialize environment
setup:
	@for dir in $(ACTIVE_DIRS); do \
		$(MKDIR) $(BASE_PATH)/$$dir/{md,tex,img} 2>/dev/null || true; \
		$(MKDIR) $(CACHE_DIR)/$$dir 2>/dev/null || true; \
	done

# Build the Jekyll site with specific active directories
site: setup
	@echo "Building Jekyll site..."
	ACTIVE_DIRS="$(ACTIVE_DIRS)" $(JEKYLL) build
	$(call UPDATE_CACHE,jekyll)

# Generate PDFs for active directories
pdf: $(addprefix pdf-, $(ACTIVE_DIRS))
	@echo "PDF generation completed for: $(ACTIVE_DIRS)"

# Pattern rule for PDF generation with caching
pdf-%:
	@echo "Checking changes for $*..."
	@if [ -d "$(BASE_PATH)/$*" ] && [ -f "$(BASE_PATH)/$*/Makefile" ]; then \
		if [ ! -f "$(call CACHE_FILE,$*)" ] || \
		   [ -n "$$(find $(BASE_PATH)/$* -type f -newer $(call CACHE_FILE,$*))" ]; then \
			echo "Changes detected, rebuilding $*..."; \
			$(MAKE) -C $(BASE_PATH)/$* pdf \
				LATEX_TEMP=$(CURDIR)/$(LATEX_TEMP) \
				PDF_OUTPUT=$(CURDIR)/$(PDF_OUTPUT) \
				CACHE_DIR=$(CURDIR)/$(CACHE_DIR) \
				PROJECT=$* && \
			$(call UPDATE_CACHE,$*); \
		else \
			echo "No changes detected for $*, skipping..."; \
		fi \
	else \
		if [ ! -d "$(BASE_PATH)/$*" ]; then \
			echo "Directory $(BASE_PATH)/$* not found"; \
		elif [ ! -f "$(BASE_PATH)/$*/Makefile" ]; then \
			echo "Makefile not found in $(BASE_PATH)/$*"; \
		fi; \
		exit 1; \
	fi

# Watch for changes and rebuild
watch:
	@echo "Watching for changes..."
	@while true; do \
		$(MAKE) all; \
		inotifywait -r -e modify,create,delete $(BASE_PATH); \
	done

# Clean everything
clean:
	@echo "Cleaning up..."
	@for dir in $(AVAILABLE_DIRS); do \
		if [ -d "$(BASE_PATH)/$$dir" ] && [ -f "$(BASE_PATH)/$$dir/Makefile" ]; then \
			echo "Cleaning $$dir..."; \
			$(MAKE) -C $(BASE_PATH)/$$dir clean \
				LATEX_TEMP=$(CURDIR)/$(LATEX_TEMP) \
				PDF_OUTPUT=$(CURDIR)/$(PDF_OUTPUT) \
				PROJECT=$$dir; \
		fi \
	done
	@echo "Removing temporary directories..."
	$(RM) $(LATEX_TEMP)
	$(RM) $(PDF_OUTPUT)
	$(RM) $(CACHE_DIR)
	$(RM) _site
	@echo "Clean complete."

# Status report with cache information
status:
	@echo "Available directories in $(BASE_PATH)/:"
	@if [ "$(AVAILABLE_DIRS)" = "" ]; then \
		echo "  No project directories found"; \
	else \
		for dir in $(AVAILABLE_DIRS); do \
			echo "  - $$dir"; \
			if [ -f "$(BASE_PATH)/$$dir/Makefile" ]; then \
				echo "    (has Makefile)"; \
				if [ -f "$(call CACHE_FILE,$$dir)" ]; then \
					echo "    (cached: $$(stat -c %y $(call CACHE_FILE,$$dir)))"; \
				else \
					echo "    (not cached)"; \
				fi \
			else \
				echo "    (no Makefile)"; \
			fi; \
		done; \
	fi
	@echo "\nCurrently active:"
	@if [ "$(ACTIVE_DIRS)" = "" ]; then \
		echo "  No active directories"; \
	else \
		for dir in $(ACTIVE_DIRS); do \
			echo "  - $$dir"; \
		done; \
	fi
	@echo "\nBuild configuration:"
	@echo "  Base path: $(BASE_PATH)"
	@echo "  Temp directory: $(LATEX_TEMP)"
	@echo "  PDF output: $(PDF_OUTPUT)"
	@echo "  Cache directory: $(CACHE_DIR)"

# Selective compilation with validation
select:
	@if [ "$(DIRS)" = "" ]; then \
		echo "Usage: make select DIRS=\"dir1 dir2\""; \
		exit 1; \
	fi
	@for dir in $(DIRS); do \
		if [ ! -d "$(BASE_PATH)/$$dir" ]; then \
			echo "Error: Directory $$dir not found in $(BASE_PATH)/"; \
			exit 1; \
		fi; \
	done
	@echo "Building only: $(DIRS)"
	@$(MAKE) ACTIVE_DIRS="$(DIRS)" all

# Initialize a new project with enhanced template
init:
	@if [ "$(PROJECT)" = "" ]; then \
		echo "Error: Specify project name with PROJECT=project_name"; \
		exit 1; \
	fi
	@if [ -d "$(BASE_PATH)/$(PROJECT)" ]; then \
		echo "Error: Directory $(PROJECT) already exists"; \
		exit 1; \
	fi
	@echo "Creating structure for project $(PROJECT)..."
	@$(MKDIR) $(BASE_PATH)/$(PROJECT)/{md,tex,img}
	@$(MKDIR) $(CACHE_DIR)/$(PROJECT)
	@cp templates/Makefile.local $(BASE_PATH)/$(PROJECT)/Makefile || \
		echo "Warning: Could not copy template Makefile. You'll need to create it manually."
	@echo "# $(PROJECT)" > $(BASE_PATH)/$(PROJECT)/md/index.md
	@echo "Project $(PROJECT) initialized in $(BASE_PATH)/$(PROJECT)"
	@echo "Created directories:"
	@echo "  - $(BASE_PATH)/$(PROJECT)/md    (for markdown files)"
	@echo "  - $(BASE_PATH)/$(PROJECT)/tex   (for additional latex files)"
	@echo "  - $(BASE_PATH)/$(PROJECT)/img   (for images)"
	@if [ -f "$(BASE_PATH)/$(PROJECT)/Makefile" ]; then \
		echo "Local Makefile copied."; \
	fi
