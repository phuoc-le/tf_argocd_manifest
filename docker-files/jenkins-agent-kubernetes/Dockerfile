FROM jenkins/inbound-agent:alpine as jnlp

FROM node:20-alpine

RUN apk -U add openjdk17-jre git curl openssl bash kustomize
RUN apk -U add step-cli step-certificates

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod 755 kubectl \
    && mv kubectl /bin

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && ls -la && chmod +x get_helm.sh && sh get_helm.sh

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
