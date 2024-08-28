ARG ERIC_ENM_SLES_EAP6_IMAGE_NAME=eric-enm-sles-eap6
ARG ERIC_ENM_SLES_EAP6_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-enm
ARG ERIC_ENM_SLES_EAP6_IMAGE_TAG=1.7.0-1

FROM ${ERIC_ENM_SLES_EAP6_IMAGE_REPO}/${ERIC_ENM_SLES_EAP6_IMAGE_NAME}:${ERIC_ENM_SLES_EAP6_IMAGE_TAG}

ARG BUILD_DATE=unspecified
ARG IMAGE_BUILD_VERSION=unspecified
ARG GIT_COMMIT=unspecified
ARG ISO_VERSION=unspecified
ARG RSTATE=unspecified

LABEL \
com.ericsson.product-number="CXC 174 1910" \
com.ericsson.product-revision=$RSTATE \
enm_iso_version=$ISO_VERSION \
org.label-schema.name="ENM Accesscontrol Service Group" \
org.label-schema.build-date=$BUILD_DATE \
org.label-schema.vcs-ref=$GIT_COMMIT \
org.label-schema.vendor="Ericsson" \
org.label-schema.version=$IMAGE_BUILD_VERSION \
org.label-schema.schema-version="1.0.0-rc1"

RUN zypper install -y ERICmodelservice_CXP9030595 \
    ERICmodelserviceapi_CXP9030594 \
    ERICpib_CXP9030194 \
    ERICserviceframework_CXP9031003 \
    ERICserviceframeworkmodule_CXP9031004 \
    ERICcryptographyservice_CXP9031013 \
    ERICcryptographyserviceapi_CXP9031014 \
    ERICmediationengineapi_CXP9031505 \
    ERICpostgresqljdbc_CXP9031176 \
    ERICpolicyengineservice_CXP9031906 \
    ERICaccesscontrolservice_CXP9032624 \
    ERICgenericidentitymgmtpostgresql_CXP9031932 \
    sles_base_os_repo:postgresql10 \
    ERICopenidmaccesspolicies_CXP9031742 \
    ERICvaultloginmodule_CXP9036201 \
    ERICpostgresutils_CXP9038493 && \
    zypper download ERICenmsgaccesscontrol_CXP9032026 && \
    rpm -ivh --replacefiles /var/cache/zypp/packages/enm_iso_repo/ERICenmsgaccesscontrol_CXP9032026*.rpm --nodeps --noscripts && \
    rm -f /ericsson/3pp/jboss/bin/pre-start/oomKillerTuning.sh  && \
    zypper clean -a

RUN mkdir -p /opt/rh/postgresql
RUN ln -s /usr/lib/postgresql10/bin /opt/rh/postgresql/bin

RUN sed -i '62s/-aes-128-cbc -kfile/-aes-128-cbc -md md5 -kfile/g' /ericsson/idenmgmt/bin/clean_open_idenmgmt_transaction.sh /ericsson/idenmgmt/bin/install_idenmgmt_db.sh

ENV ENM_JBOSS_SDK_CLUSTER_ID="accesscontrol" \
    ENM_JBOSS_BIND_ADDRESS="0.0.0.0" \
    JBOSS_CONF="/ericsson/3pp/jboss/app-server.conf"

EXPOSE 1636 4320 4447 7999 8080 8085 8445 9990 9999 12987
