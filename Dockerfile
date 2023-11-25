FROM debian:trixie-slim

LABEL project="AeneaAI"
LABEL description="This image runs Ollama and loads orca-mini model for AeneaAI"
LABEL maintainer_name="Sergio Fernández Cordero"
LABEL maintainer_email="sergio@fernandezcordero.net"

# Environment and dependencies
RUN apt -y update && apt -y upgrade && \
    apt -y install bash build-essential net-tools psmisc ca-certificates && \
    apt -y clean && \
    mkdir -p /opt/aenea && \
    addgroup --gid 1001 aenea && \
    adduser --gid 1001 --uid 1001 --home /opt/aenea --disabled-login aenea && \
    mkdir -p /opt/aenea/ai/server/ && \
    mkdir -p /opt/aenea/ai/model/

# Deploy
ADD models/* /opt/aenea/ai/model
ADD scripts/* /opt/aenea/ai/server
ADD /binary/* /opt/aenea/ai/server
RUN chown -R aenea:aenea /opt/aenea && \
    chmod +x /opt/aenea/ai/server/ollama && \
    chmod +x /opt/aenea/ai/server/run_ollama_model.sh
# Run
USER aenea
ENTRYPOINT ["/opt/aenea/ai/server/run_ollama_model.sh"]
