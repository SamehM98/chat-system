
FROM ruby:3.2.2

ARG APP_USER_ID

ENV APP_USER             chat_system_backend_user
ENV PROJECT_DIRECTORY    chat_system
ENV USER_HOME_DIRECTORY  /home/${APP_USER}
ENV APP_PATH             ${USER_HOME_DIRECTORY}/${PROJECT_DIRECTORY}
ENV CACHE_DIR            ${APP_PATH}/tmp/cache
ENV NODE_MODULES_DIR     ${APP_PATH}/node_modules
ENV BUNDLED_GEMS_PATH    ${APP_PATH}/.bundled_gems
ENV BUNDLE_APP_CONFIG    ${BUNDLED_GEMS_PATH}
ENV BUNDLE_BIN           ${BUNDLED_GEMS_PATH}/bin
ENV BUNDLE_PATH          ${BUNDLED_GEMS_PATH}
ENV PATH                 ${BUNDLE_BIN}:${PATH}


RUN apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y default-libmysqlclient-dev nodejs


WORKDIR ${USER_HOME_DIRECTORY}


RUN useradd -md ${USER_HOME_DIRECTORY} -u ${APP_USER_ID}  -s /bin/bash ${APP_USER} && \
    mkdir -p ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR} && \
    chown -R ${APP_USER_ID}:${APP_USER_ID} ${APP_PATH} ${BUNDLED_GEMS_PATH} ${CACHE_DIR} ${NODE_MODULES_DIR}



# Save Rails Console's history
RUN echo  "require 'irb/ext/save-history'\n\
  IRB.conf[:SAVE_HISTORY] = 500\n\
  IRB.conf[:HISTORY_FILE] = '${APP_PATH}/.irb-history'\n" >> ${USER_HOME_DIRECTORY}/.irbrc

# Copy entrypoint script
COPY docker/entrypoint.sh ${USER_HOME_DIRECTORY}/entrypoint.sh
RUN chmod +x ${USER_HOME_DIRECTORY}/entrypoint.sh

USER ${APP_USER_ID}
WORKDIR ${APP_PATH}


ENTRYPOINT ["/home/chat_system_backend_user/entrypoint.sh"]
