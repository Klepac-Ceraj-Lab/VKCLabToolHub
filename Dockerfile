#####
# Xtay-Pricing Shiny App
#####

FROM rocker/shiny:4.4.2

ENV R_LIBS_SITE=/usr/local/lib/R/site-library

RUN apt-get update && \
  apt-get install -y cmake build-essential gcc \
  libz-dev libpq-dev libssl-dev libcurl4-openssl-dev libxml2-dev libsodium-dev libsodium23 \
  libxt6 libx11-dev libsm6 libxext6 libboost-all-dev tzdata && \
  rm -rf /var/lib/apt/lists/*

RUN echo "TZ=\${TZ}" >> ${R_HOME}/etc/Renviron.site

RUN Rscript -e "withCallingHandlers( install.packages('shiny.router'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('bslib'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('DBI'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('RSQLite'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('httr'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('DT'), warning = function(w) stop(w) )"
RUN Rscript -e "withCallingHandlers( install.packages('rlang'), warning = function(w) stop(w) )"

WORKDIR /app
COPY --chmod=777 . /app

COPY shiny-server.conf /etc/shiny-server/

EXPOSE 3838