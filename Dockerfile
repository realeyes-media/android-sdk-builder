FROM openjdk:8

ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_VERSION=27 \
    ANDROID_BUILD_TOOLS_VERSION=28.0.3

# Update and Install Dependencies
RUN apt-get update && apt-get install gawk bash wget -y && apt-get upgrade -y wget bash && chsh -s /bin/bash

# Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
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

RUN mkdir -p /app
WORKDIR /app

CMD [ "/bin/bash" ]
