ARG KEYCLOAK_VERSION
FROM keycloak/keycloak:${KEYCLOAK_VERSION} as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Build to use PostgreSQL database
ENV KC_DB=postgres

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# Use PostgreSQL
ENV KC_DB=postgres

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]
