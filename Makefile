
# Makefile

cmd=""
path="src"
OS := $(shell uname)
cp = ""

up:
	docker-compose down &&  docker-compose -f docker-compose.yml up -d --remove-orphans --force-recreate
dockerFirstInit:
	docker-compose build && make up
down:
	docker-compose down

bash:
	docker exec -it -u root app_php bash
log:
	docker exec -it app_httpd bash -c 'tail -f /var/log/api_error.log'

init:
	docker exec -it app_php bash -c 'composer install --prefer-dist \
	&& php bin/console cache:clear'

load-fixtures:
	docker exec -it app_php bash -c 'php bin/console doctrine:fixtures:load'

# exemple make sf cmd=cache:clear
sf:
	docker exec -it app_php bash -c 'php bin/console $(cmd)'
sfCompo:
	docker exec -it app_php bash -c 'composer req $(cp) -vvv'
phpcs:
	docker exec -it app_php bash -c ' vendor/bin/php-cs-fixer fix $(path)'

mysql:
	docker-compose exec mysql bash -c 'mysql -u root -proot -D app'
mysqlIp:
	docker inspect app_mysql

logs:
	make up && docker-compose logs -f

fixuser:
	sudo groupadd docker && sudo usermod -aG docker $USER
