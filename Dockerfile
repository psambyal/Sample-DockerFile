FROM dockerhub.rnd.amadeus.net:5000/ubuntu:trusty

ENV SONAR_RUNNER_VERSION=2.4

ENV JDK_VERSION=1.8.0_121
ENV JDK_DOWNLOAD_URL=http://download.oracle.com/otn-pub/java/jdk/8u151-b12/
ENV JDK_ZIP_FILE=jdk-8-linux-x64.tar.gz

#installing wget and unzip
RUN apt-get update && apt-get -y install wget && apt-get -y install unzip && apt-get -y install zip && apt-get -y install curl
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | sudo bash -
RUN apt-get install --yes nodejs
RUN apt-get install --yes build-essential

#ChromeDriver
RUN apt-get install -y libappindicator1 fonts-liberation libasound2 libgconf-2-4 libnspr4 libxss1 libnss3 xdg-utils && wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i google-chrome*.deb

#Java
RUN cd /opt && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \ 
RUN cd /opt && tar -xvf ${JDK_ZIP_FILE}
RUN  cd /opt && ln -s /opt/jdk${JDK_VERSION} jdk

#Sonar-Scanner
RUN mkdir -p /sonar-scanner \
&& wget -q http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/${SONAR_RUNNER_VERSION}/sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip -P /sonar-runner \
&& unzip sonar-runner/sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip -d sonar-scanner/ \
&& chmod 777 -R /sonar-runner \
&& rm -f sonar-runner/sonar-runner-dist-${SONAR_RUNNER_VERSION}.zip


ENV SONAR_RUNNER_HOME=/sonar-runner/
ENV JAVA_HOME=/opt/jdk
ENV CHROME_BIN=/usr/bin/google-chrome
ENV PATH="/opt/sf-release/bin:${SONAR_RUNNER_HOME}/bin:${JAVA_HOME}/bin:${PATH}"
