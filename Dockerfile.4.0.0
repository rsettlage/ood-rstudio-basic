
## using rocker/verse and adding some stuff for ARC

FROM rocker/verse:4.0.0

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/
ENV PATH="${PATH}:/miniconda3/bin"

RUN apt update \
  && apt-get install -y curl wget gzip

RUN Rscript -e "install.packages(Ncpus=6,c('reticulate', 'ggpubr', 'rlecuyer', 'pkgmaker', 'RcppEigen'))"
RUN tlmgr install harvard ctable multirow eurosym comment setspace enumitem \
  && tlmgr path add
RUN chown -R root:staff /opt/ \
  && chmod -R g+wx /opt/ \
  && tlmgr path add

RUN Rscript -e "library(reticulate); install_miniconda(path='/miniconda3',update=TRUE,force=TRUE)"

RUN apt-get clean
RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
RUN echo 'R_ENVIRON=~/.Renviron.OOD \
      \nR_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site

