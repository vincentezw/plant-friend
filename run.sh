docker run -d \
 --name=plantfriend \
 --hostname=plantfriend \
 --privileged \
 --network=host \
 -e "RAILS_SERVE_STATIC_FILES=true" \
 -e TZ=Europe/Dublin \
 -e "MYSQL_USER=YOUR_USER" \
 -e "MYSQL_PASSWORD=YOUR_PASSWORD" \
 -e "MYSQL_DATABASE=plant_friend" \
 -e "MYSQL_HOST=127.0.0.1" \
 -e "MYSQL_PORT=3306" \
 --restart unless-stopped \
plantfriend
