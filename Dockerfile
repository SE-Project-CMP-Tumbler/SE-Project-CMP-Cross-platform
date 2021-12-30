FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update 
RUN apt-get install -y curl git unzip android-sdk nginx wget

# Download cmdtools for android sdk
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
    unzip commandlinetools-linux-7583922_latest.zip && \
    rm commandlinetools-linux-7583922_latest.zip

# Install cmdtools in the right location
RUN mkdir -p /usr/lib/android-sdk/cmdline-tools/latest && \
    mv cmdline-tools/* /usr/lib/android-sdk/cmdline-tools/latest && \
    rm -rf cmdline-tools

# Start the nginx server
RUN service nginx start

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Run flutter doctor
RUN flutter doctor -v

# Set the working directory to the app files within the container
WORKDIR /flutter

COPY . /flutter

# Clean the Project
RUN flutter clean

# Get App Dependencies
RUN flutter pub get

# Accept licenses
RUN yes | flutter doctor --android-licenses

# Build the app for the mobile
RUN flutter build apk

# Build the app for the web
RUN flutter build web

# Clean the serving directory
RUN rm /var/www/html/*

# Copy the flutter web to where nginx serves
RUN cp -r /flutter/build/web /var/www/html

# Document the exposed port
EXPOSE 80
