FROM nginx
#COPY . /usr/share/nginx/html

RUN apt-get update 
RUN apt-get install -y curl git unzip android-sdk tree

RUN tree -f /usr | grep sdkmanager
RUN false

# Set the working directory to the app files within the container
WORKDIR /flutter

COPY . /flutter

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter

# Set flutter path
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable flutter web
RUN flutter channel master
RUN flutter upgrade
RUN flutter config --enable-web

# Run flutter doctor
RUN flutter doctor --android-licenses

# Clean the Project
RUN flutter clean

# Get App Dependencies
RUN flutter pub get

# Build the app for the mobile
RUN flutter build apk --release

# Build the app for the web
RUN flutter build web

RUN cp -r /flutter/build/web /usr/share/nginx/html

# Document the exposed port
EXPOSE 80



