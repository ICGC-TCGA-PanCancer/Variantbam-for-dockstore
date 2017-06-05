FROM ubuntu:14.04
LABEL maintainer Solomon.Shorser@oicr.on.ca
LABEL description="This docker image contains VariantBam by Jeremiah Wala (jwala@broadinstitute.org).\
See https://github.com/jwalabroad/VariantBam for more information about VariantBam."

RUN mkdir -p /opt/variantbam_workspace
WORKDIR /opt/variantbam_workspace

ENV VARIANT_BAM_VERSION=v1.4.3

RUN apt-get update
RUN apt-get install -y git=1:1.9.1-1ubuntu0.5 g++ zlib1g-dev make libboost-all-dev \
	rtmpdump=2.4+20121230.gitdf6c518-1ubuntu0.1 bash=4.3-7ubuntu1.7 sudo=1.8.9p5-1ubuntu1.4 \
	openldap=2.4.31-1+nmu2ubuntu8.4

RUN git clone --recursive https://github.com/walaj/VariantBam.git && cd VariantBam && git checkout $VARAINT_BAM_VERSION && git status
# && cd SnowTools && git status

RUN cd VariantBam && ./configure && make
RUN ln -s  /opt/variantbam_workspace/VariantBam/src/variant /bin/variant
# self-test - find out why the command on the github page (VariantBam/src/variant test/small.bam -g 'X:1,000,000-1,100,000' -r mapq[10,100] -c counts.tsv -o mini.bam -v) doesn't seem to work.
#RUN cd VariantBam && variant test/small.bam -o mini.bam -v && stat mini.bam

RUN apt-get install -y samtools

COPY ./run_variant_bam.sh /opt/variantbam_workspace/run_variant_bam.sh
RUN chmod a+rw /opt/variantbam_workspace/ && chmod a+x /opt/variantbam_workspace/run_variant_bam.sh
