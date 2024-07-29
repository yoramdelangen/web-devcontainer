#!/usr/local/env bash

download_php_version() {
    PHP_VERSION=${1}

    wget https://dl.static-php.dev/static-php-cli/bulk/php-$PHP_VERSION-cli-linux-x86_64.tar.gz && \
        tar xzvf php-$PHP_VERSION-cli-linux-x86_64.tar.gz && \
        mv php /usr/local/bin/ && \
        rm php-$PHP_VERSION-cli-linux-x86_64.tar.gz

    echo "Download of PHP $PHP_VERSION completed!"
}

download_latest_nvim() {
    # Install Neovim from source via tarbal
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
        tar -C /opt -xzvf nvim-linux64.tar.gz && \
        rm nvim-linux64.tar.gz && \
        echo 'export PATH="$PATH:"/opt/nvim-linux64/bin' >> ~/.bashrc

    echo "Download and installed latest Neovim version!"
}
