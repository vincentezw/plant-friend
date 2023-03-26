docker run -d \
 --name=plantfriend \
 --hostname=plantfriend \
 --privileged \
 --network=host \
 -e "RAILS_SERVE_STATIC_FILES=true" \
 -e TZ=Europe/Dublin \
 -e "MYSQL_USER=vincent" \
 -e "MYSQL_PASSWORD=Swansk1k1ng" \
 -e "MYSQL_DATABASE=plant_friend" \
 -e "MYSQL_HOST=127.0.0.1" \
 -e "MYSQL_PORT=3306" \
 --restart unless-stopped \
plantfriend
