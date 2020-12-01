
## using rocker/verse and adding some stuff for ARC

FROM rocker/verse:4.0.3

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
ENV RSTUDIO_VERSION=${RSTUDIO_VERSION:-1.2.5042}
ENV PATH="${PATH}:/miniconda3/bin"

RUN apt update \
  && apt-get install -y curl wget gzip jags

RUN Rscript -e "install.packages(Ncpus=6,c('rjags', 'tidyverse', 'dplyr', 'devtools', 'data.table', 'reticulate', 'ggpubr', 'rlecuyer', 'pkgmaker', 'gtools', 'RcppEigen', 'ggrepel', 'gplots'))"
RUN tlmgr install harvard ctable multirow eurosym comment setspace enumitem \
  && tlmgr path add
RUN chown -R root:staff /opt/ \
  && chmod -R g+wx /opt/ \
  && tlmgr path add

RUN Rscript -e "library(reticulate); install_miniconda(path='/miniconda3',update=TRUE,force=TRUE)"

## DOWNGRADING to Rstudio 1.2* to get past a 1.3 change which is breaking auth/pam
## sounds like bug is fixed in 1.4 when released ....
RUN wget -q "http://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.2.5042-amd64.deb" \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb

RUN apt-get clean
#RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
#RUN echo 'R_ENVIRON=~/.Renviron.OOD \
RUN echo 'R_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site
RUN sed -i '/auth-none=1/auth-none=0/' /etc/rstudio/disable_auth_rserver.conf 
