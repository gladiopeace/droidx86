#please beware that ubuntu is bullcrap!
FROM ubuntu
MAINTAINER Evil  "evil@sofuckinevil.hell"
ENV ROOTPASSWORD stupidpass

EXPOSE 22
EXPOSE 5900
#EXPOSE 5555
EXPOSE 6080
#EXPOSE 6081
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y install software-properties-common bzip2 ssh net-tools openssh-server socat curl && \
    apt-get install openjdk-8-jre libqt5widgets5 python git -y
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN wget -qO- https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | \
    tar xvz -C /usr/local/ && \
    mv /usr/local/android-sdk-linux /usr/local/android-sdk && \
    chown -R root:root /usr/local/android-sdk/


ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

RUN ( sleep 4 && while [ 1 ]; do sleep 1; echo y; done ) | echo y | android update \
sdk --all --filter  android-24,sys-img-x86-google_apis-24,build-tools=24.0.3,extra-android-m2repository \
--no-ui --force && echo "y" | android update adb

RUN echo "y"|  android update sdk --no-ui --filter  platform-tools,tools 

#RUN echo no | android create avd --target android-24 --abi google_apis/x86 --name avd1 --skin WXGA800-7in 

RUN mkdir -p /usr/local/android-sdk/tools/keymaps && \
touch /usr/local/android-sdk/tools/keymaps/en-us

RUN mkdir -p /usr/local/android-sdk/tools/lib/pc-bios/keymaps && \
touch /usr/local/android-sdk/tools/lib/pc-bios/keymaps/en-us

RUN if [ ! -d /usr/local/android-sdk/tools/qemu/linux-x86 ] ;then \
 mkdir /usr/local/android-sdk/tools/qemu/linux-x86 ;fi && \
ln /usr/local/android-sdk/tools/qemu/linux-x86_64/qemu-system-i386 \
/usr/local/android-sdk/tools/qemu/linux-x86/qemu-system-i386

RUN git clone https://github.com/kanaka/noVNC.git

#RUN echo "hw.keyboard=yes" >> /root/.android/avd/avd1.avd/config.ini

#RUN android create avd -t android-24  -b x86 -d 28  -n avd1 -b x86 --force
#RUN ln -s /usr/share/qemu/keymaps /usr/local/android-sdk/tools/lib/pc-bios/keymaps
ADD *.sh /root/
RUN  chmod +x /root/env.sh

RUN /root/env.sh  >> /root/.bashrc
##

RUN mkdir /var/run/sshd && \
    echo "root:$ROOTPASSWORD" | chpasswd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
echo "export VISIBLE=now" >> /etc/profile
ENV NOTVISIBLE "in users profile"
ENTRYPOINT /root/entry.sh
