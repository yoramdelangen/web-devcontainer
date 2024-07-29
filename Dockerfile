FROM --platform=linux/amd64 debian:latest

RUN apt update && apt install -y git grep curl wget build-essential procps file openssl

SHELL ["/bin/bash", "-c"]

# Set default nvim command to start up editor
ENV NVIM_PROFILE webdev
ENV NODE_VERSION 22
ENV TERM=xterm-256color
ENV VOLTA_HOME /root/.volta
ENV PATH $VOLTA_HOME/bin:$PATH

COPY .bashrc ~/
COPY php.ini /lib

ARG PHP_VERSION=8.3.9

# install homebrew linux
# RUN test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)" && \
#     test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
#     echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc

# Install Neovim from source via tarbal
RUN  wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -C /opt -xzvf nvim-linux64.tar.gz && \
    rm nvim-linux64.tar.gz && \
    echo 'export PATH="$PATH:"/opt/nvim-linux64/bin' >> ~/.bashrc

RUN curl https://get.volta.sh | bash && \
    echo 'export PATH="$PATH:$VOLTA_HOME/bin"' >> ~/.bashrc
RUN volta install node && volta install yarn
RUN yarn config set --home enableTelemetry 0;

# Download static PHP
RUN wget https://dl.static-php.dev/static-php-cli/bulk/php-$PHP_VERSION-cli-linux-x86_64.tar.gz && \
    tar xzvf php-$PHP_VERSION-cli-linux-x86_64.tar.gz && \
    mv php /usr/local/bin/ && \
    rm php-$PHP_VERSION-cli-linux-x86_64.tar.gz

# Download and install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

# Download and install global PHP packages....
RUN composer global require --dev deployer/deployer && \
    composer global require --dev friendsofphp/php-cs-fixer

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["bash"]
