# Directory configuration
BASE_PATH := arsenale
AVAILABLE_DIRS := $(shell find $(BASE_PATH) -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
ACTIVE_DIRS := $(AVAILABLE_DIRS)

# Build configuration
LATEX_TEMP := _latex_temp
PDF_OUTPUT := tipografia

# Make sure these directories exist
$(shell mkdir -p $(LATEX_TEMP) $(PDF_OUTPUT))

.PHONY: all clean pdf site setup status select

# Build everything
all: setup site pdf

# Setup necessary directories
setup:
	mkdir -p $(LATEX_TEMP)
	mkdir -p $(PDF_OUTPUT)
	@for dir in $(ACTIVE_DIRS); do \
		mkdir -p $(BASE_PATH)/$$dir/tex 2>/dev/null || true; \
	done

# Build the Jekyll site with specific active directories
site: setup
	ACTIVE_DIRS="$(ACTIVE_DIRS)" bundle exec jekyll build

# Generate PDFs for active directories
pdf: $(addprefix pdf-, $(ACTIVE_DIRS))
	@echo "PDF generation completed for: $(ACTIVE_DIRS)"

# Pattern rule for PDF generation
pdf-%:
	@echo "Generating PDF for $*..."
	@if [ -d "$(BASE_PATH)/$*" ] && [ -f "$(BASE_PATH)/$*/Makefile" ]; then \
		$(MAKE) -C $(BASE_PATH)/$* pdf \
			LATEX_TEMP=$(CURDIR)/$(LATEX_TEMP) \
			PDF_OUTPUT=$(CURDIR)/$(PDF_OUTPUT) \
			PROJECT=$*; \
	else \
		if [ ! -d "$(BASE_PATH)/$*" ]; then \
			echo "Directory $(BASE_PATH)/$* not found"; \
		elif [ ! -f "$(BASE_PATH)/$*/Makefile" ]; then \
			echo "Makefile not found in $(BASE_PATH)/$*"; \
		fi; \
		exit 1; \
	fi

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
	rm -rf $(LATEX_TEMP)
	rm -rf $(PDF_OUTPUT)
	rm -rf _site
	@echo "Clean complete."

# Status report
status:
	@echo "Available directories in $(BASE_PATH)/:"
	@if [ "$(AVAILABLE_DIRS)" = "" ]; then \
		echo "  No project directories found"; \
	else \
		for dir in $(AVAILABLE_DIRS); do \
			echo "  - $$dir"; \
			if [ -f "$(BASE_PATH)/$$dir/Makefile" ]; then \
				echo "    (has Makefile)"; \
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

# Selective compilation
# Usage: make select DIRS="dir1 dir2"
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

# Initialize a new project
# Usage: make init PROJECT=nome_progetto
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
	@mkdir -p $(BASE_PATH)/$(PROJECT)/{md,tex,img}
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
