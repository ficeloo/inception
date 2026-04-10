# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcros <tcros@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/08/20 11:03:25 by tcros             #+#    #+#              #
#    Updated: 2026/04/02 16:43:31 by tcros            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

### VARIABLES ###
# NAME #
NAME	= inception

# COMPILATION #
BUILD	= docker compose
DFLAGS 	= -f
DOWN	= down
UP		= up --build
CLEAN_F	= --rmi all -v

# SOURCES #
DAT_PATH= /home/tcros/data
SRC 	= srcs/docker-compose.yml

### COULEURS ###
GREEN	= \033[3;32m
RED		= \033[0;31m
ORANGE	= \033[1;33m
BLUE	= \033[0;34m
NC		= \033[0m


### REGLES D'INFERENCES ###
# REGLES PHONY #
.PHONY: all down clean fclean re

help:
	@printf "$(BLUE)Commandes du projet Inception :$(NC)\n"
	@printf "  $(GREEN)make all$(NC)     : Lance le projet\n"
	@printf "  $(GREEN)make down$(NC)    : Arrete les containers\n"
	@printf "  $(GREEN)make re$(NC)      : Relance tout (down + all)\n"
	@printf "  $(GREEN)make clean$(NC)   : Supprime les dockers mais garde les donnees\n"
	@printf "  $(RED)make fclean$(NC)  : Supprime tout (Donnees incluses)\n"

all:
	@printf "$(BLUE)[INFO] Dockerisation...$(NC)\n"
	@mkdir -p $(DAT_PATH)/mariadb
	@mkdir -p $(DAT_PATH)/wordpress
	$(BUILD) $(DFLAGS) $(SRC) $(UP)
	@printf "$(GREEN)[SUCCES] Docker configure avec succes !$(NC)\n"

down:
	@printf "$(BLUE)[DOWN] Arret des dockers...$(NC)\n"
	$(BUILD) $(DFLAGS) $(SRC) $(DOWN)

clean:
	@printf "$(ORANGE)[CLEAN] Suppressions des dockers...$(NC)\n"
	$(BUILD) $(DFLAGS) $(SRC) $(DOWN) $(CLEAN_F)

fclean: clean
	@printf "$(ORANGE)[CLEAN] Suppressions des donnees dockers...$(NC)\n"
	@sudo rm -rf $(DAT_PATH)
	@docker system prune -a --force
	
re: down all
