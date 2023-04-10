# Plant Friend
Plant Friend is a simply plant maintenance tracker for your houseplants. Plant Friend will remind you when you should water, fertlise, mist and clean a plant.

Written in Rails.

## Features:
- Reminders to mist, water, fertilise or clean a plant.
- Add images to plants.
- Search and import plant families from [Perenial](https://perenual.com)
- Add/edit/remove rooms. Rooms have a "name" and "sun level"
- Add/edit/remove plant families. A plant family has a watering interval, misting.
- Add/edit/remove plants. Plants belong to a family and a room.

## Todo:
Lots.
- Integrate with a service like Plant.net to obtain information from picture?
- Integrate with a service to obtain plant metadata?
- Maybe a neater Remix interface in the future, add GraphQL.
- You name it. PRs welcome.

## Screenshots:
![Task screen](https://github.com/vincentezw/plant-friend/blob/main/screenshot/tasks.png)

![Plant info screen](https://github.com/vincentezw/plant-friend/blob/main/screenshot/plant.png)

Installation with docker:

- Open your database console (`mysql`) and create a database (`create database plant_friend;`)
- Grant permissions to your user by running:
  `grant all privileges on plant_friend.* TO 'USER_NAME'@'HOST' identified by 'PASSWORD';`
  (replace USER_NAME and PASSWORD with your values)
- To build the image, run `docker build -t plantfriend .`
- You can use the included shell script `run.sh` to launch the container. Take note to alter the environment variables
  on lines 7-11 to reflect your MySQL user, password and database.
- Get a [Perenial](https://perenual.com) API code and add it on line 13, setting the `PERENUAL_API_CODE` environment
  variable. This will allow you to import plant family information from Perenial.
- Run `docker exec plantfriend rake db:migrate db:seed` to run the database migrations and seed data.
- Plant Friend should now be available on port 3200 of your host.

## short term TODO (bugs)

-delete plant goes to home screen?
-skip first three tasks?
