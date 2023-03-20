help: 
	@echo init       Install the pip dependencies on the starterkit.  
	@echo Start       Run your local server.  
										   

init: ## Install the pip dependencies on the starterkit.
	@pip install -r requirements.txt
	

start: ## Run your local server
	@python manage.py

