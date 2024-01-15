FROM rocker/shiny:4.3.2

MAINTAINER Khabat Vahabi <kvahabi@ipb-halle.de>

LABEL Description="Small Shiny App to augment MetFamily project files with external information."

RUN R -e 'install.packages(c("readxl", "data.table"))'

WORKDIR /srv/shiny-server
RUN rm -rf *
ADD . /srv/shiny-server/MetFamilyTools
