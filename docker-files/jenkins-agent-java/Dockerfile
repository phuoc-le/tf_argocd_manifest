FROM jenkins/inbound-agent:alpine as jnlp

FROM maven:3.6-openjdk-17-slim

FROM gradle:8-jdk17-alpine

RUN apk -U add git

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
