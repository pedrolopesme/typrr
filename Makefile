PORT ?= 8080

.PHONY: serve stop clean

serve: ## Start HTTP server on PORT (default 8080)
	@echo "Serving TypeFlow at http://localhost:$(PORT)"
	@python3 -m http.server $(PORT) --bind 127.0.0.1

stop: ## Kill the HTTP server on PORT
	@pkill -f "python3 -m http.server $(PORT)" 2>/dev/null && echo "Stopped" || echo "Not running"

clean: ## Remove macOS junk files
	@find . -name '.DS_Store' -delete 2>/dev/null; echo "Cleaned"
