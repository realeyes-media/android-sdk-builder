FROM openjdk:8

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=27 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3 \
    GCLOUD_DL="google-cloud-sdk-228.0.0-linux-x86_64"

# Update and Install Dependencies
RUN apt-get update && apt-get install gawk bash wget python -y && apt-get upgrade -y wget bash && chsh -s /bin/bash

# Install GCloud SDK
WORKDIR /
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${GCLOUD_DL}.tar.gz
RUN tar zxvf ${GCLOUD_DL}.tar.gz google-cloud-sdk
RUN rm ${GCLOUD_DL}.tar.gz
RUN chmod +x /google-cloud-sdk/install.sh
RUN /google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/.bashrc --additional-components app kubectl alpha beta
RUN /google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true
ENV PATH $PATH:/google-cloud-sdk/bin

# Download Android SDK
WORKDIR ${ANDROID_HOME}
RUN mkdir -p ~/.android \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && echo "y" | $ANDROID_HOME/tools/bin/sdkmanager --licenses \
    && mkdir -p ~/.android \
    && touch ~/.android/repositories.cfg
ENV PATH="${PATH}:${ANDROID_HOME}/tools/bin"

# Install Android Build Tool and Libraries
RUN sdkmanager --update
RUN echo "y" | sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

WORKDIR /app

CMD [ "/bin/bash" ]
