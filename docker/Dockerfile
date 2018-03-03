FROM bitnami/minideb:jessie
MAINTAINER Dushyant Khosla <dushyant.khosla@yahoo.com>

# === COPY FILES ===

COPY start.sh /etc/init.d/
COPY install-xsv-miller.sh /root/

# === SET ENVIRONMENT VARIABLES ===

ENV PATH="/miniconda/bin:${PATH}"
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8

# === INSTALL DEPENDENCIES ===

WORKDIR /root
RUN apt update \
  && apt install -y  wget \
                    bzip2 \
                    dtrx \
                    gcc \
                    man \
                    make \
                    flex \
                    gawk \
                    nano \
                    git \
                    datamash \
	&& wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
	&& bash miniconda.sh  -b -p /miniconda \
	&& conda config --append channels conda-forge \
  && conda create -n ds-py3 python=3.6 \
	&& conda install -n ds-py3 -y csvkit pandas jupyter jupyterlab flask requests scikit-learn seaborn pytest \
  && conda install -n ds-py3 -y -c bioconda csvtk \
	&& conda clean -i -l -t -y \
	&& rm miniconda.sh \
  && /bin/bash -c "chmod +x /root/install-xsv-miller.sh" \
  && /bin/bash -c "/root/install-xsv-miller.sh"
  && /bin/bash -c "chmod +x /etc/init.d/start.sh"

# === INITIALIZE ===

WORKDIR /home/
EXPOSE 8888
CMD ["bash"]
