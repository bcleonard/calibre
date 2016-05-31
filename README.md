# calibre

This contains the docker file and all necessary files to build a docker container for calibre.

Calibre (https://calibre-ebook.com) is probably the best e-book management system out there.  This docker container will run the server portion only.

### Preperation

Before running the container, you'll need to have the following directories predefined on the container host:
```sh
library
addbooks
```
The library directory will hold your books & database.  addbooks will be used to add books to your library.  I used:
```sh
/home/books/library
/home/books/addbooks
```
for the instructions below.  Just make sure you create them prior to starting the container.

### To run the container:

```sh
docker run -d --name=calibre -v /home/books:/data:Z -p 8080:8080 bcleonard/calibre
```

### To access Calibre:

```sh
http://<docker_host>:8080
```

### To add books to the library.  

First add your books to /home/books/addbooks, one book (all formats) per directory.  Then run the following command:
```sh
docker exec calibre /scripts/add-books.sh
```
All the books in /home/books/addbooks will be added to the library, removed from the /home/books/addbooks directory and calibre notified.

### Notes/Caveats/Issues:

1.	Previous versions of the container used to automatically run the add-books.sh script hourly via cron.  In an effect to reduce the image size and with the available of the docker exec command, that functionality has been removed.
2.	I recommend running the add-scripts.sh ad-hoc, when necessary.  You can schedule it via the host (via cron, etc).
3.	I recommend that you only pull versioned containers, not latest.  

