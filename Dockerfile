FROM centos:7

ARG LIBREOFFICE_MIRROR=https://downloadarchive.documentfoundation.org/libreoffice/old/
ARG LIBREOFFICE_VERSION=7.2.6.1

RUN yum update -y && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
    yum install -y curl cairo cups-libs cabextract dbus-glib glib2 libSM libXinerama mesa-libGL open-sans-fonts \
    gnu-free-mono-fonts gnu-free-sans-fonts gnu-free-serif-fonts cabextract unzip wget \
    https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

RUN echo "Downloading LibreOffice ${LIBREOFFICE_VERSION}..." && \
    wget --no-check-certificate -P /tmp/libreoffice/ ${LIBREOFFICE_MIRROR}${LIBREOFFICE_VERSION}/rpm/x86_64/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz && \
    tar -xf /tmp/libreoffice/LibreOffice_${LIBREOFFICE_VERSION}_Linux_x86-64_rpm.tar.gz -C /tmp/libreoffice && \
    cd /tmp/libreoffice/LibreOffice_*_Linux_x86-64_rpm/RPMS && \
    (rm -f *integ* || true) && \
    (rm -f *desk* || true) && \
    yum localinstall -y --setopt=tsflags=nodocs *.rpm && \
    yum clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/libreoffice/LibreOffice_*_Linux_x86-64_rpm && \
    rm -f /tmp/libreoffice/LibreOffice_*_Linux_x86-64_rpm.tar.gz && \
    ln -s /opt/libreoffice* /opt/libreoffice
