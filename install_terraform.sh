#! /bin/bash
sudo apt install -y unzip
wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
unzip terraform_"$tf_version"_linux_amd64.zip"
sudo mv terraform /usr/local/bin/
