FROM iliyan/jenkins-ci-php

MAINTAINER Ngoc Quang <ngocquangbb@gmail.com>


RUN service jenkins start; \
	while ! echo exit | nc -z -w 3 localhost 8080; do sleep 3; done; \
	while curl -s http://localhost:8080 | grep "Please wait"; do echo "Waiting for Jenkins to start.." && sleep 3; done; \
	echo "Jenkins started"; \
	curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack; \
	wget http://localhost:8080/jnlpJars/jenkins-cli.jar; \
	java -jar jenkins-cli.jar -s http://localhost:8080 install-plugin postbuild-task; \
	java -jar jenkins-cli.jar -s http://localhost:8080 safe-restart;
