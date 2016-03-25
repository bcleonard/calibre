FROM fedora:23
MAINTAINER Bradley Leonard <bradley@stygianresearch.com> 

# install basic development tools 
#RUN dnf -y update\
#  && dnf clean all

# install calibre cronie
RUN dnf -y install calibre cronie

# create directories
#RUN mkdir /library & mkdir /addbooks & mkdir /scripts
RUN mkdir /data & mkdir /scripts

# add crontab
ADD crontab /scripts/crontab

# add add-books.sh
ADD add-books.sh /scripts/add-books.sh
RUN chmod 755 /scripts/add-books.sh

# add the startup.sh
ADD startup.sh /scripts/startup.sh
RUN chmod 755 /scripts/startup.sh

# Expose port
EXPOSE 8080

CMD ["/scripts/startup.sh"]
