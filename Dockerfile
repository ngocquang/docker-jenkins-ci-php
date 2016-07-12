FROM iliyan/jenkins-ci-php

MAINTAINER Ngoc Quang <ngocquangbb@gmail.com>


RUN service jenkins start; \
	while ! echo exit | nc -z -w 3 localhost 8080; do sleep 3; done; \
	while curl -s http://localhost:8080 | grep "Please wait"; do echo "Waiting for Jenkins to start.." && sleep 3; done; \
	echo "Jenkins started"; \
	curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack; \
	wget http://localhost:8080/jnlpJars/jenkins-cli.jar; \
	java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin postbuild-task publish-over-ssh publish-over-ftp; \
	java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart;


# php.ini settings
RUN sed -ie 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/London/g' /etc/php5/apache2/php.ini && \
	sed -i "s/;include_path = \"\.:.*/include_path = \".:\/usr\/share\/php:\/home\/ZendFramework-1.12.3\/library\"/" /etc/php5/apache2/php.ini && \
	sed -i "s/error_reporting = .*$/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED \& ~E_WARNING/" /etc/php5/apache2/php.ini && \
	sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
	sed -i 's/\;date\.timezone\ \=/date\.timezone\ \=\ Europe\/London/g' /etc/php5/cli/php.ini && \
	sed -i "s/;include_path = \"\.:.*/include_path = \".:\/usr\/share\/php:\/home\/ZendFramework-1.12.3\/library\"/" /etc/php5/cli/php.ini && \
	sed -i "s/error_reporting = .*$/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED \& ~E_WARNING/" /etc/php5/cli/php.ini && \
	sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/cli/php.ini
