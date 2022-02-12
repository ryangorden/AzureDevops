#! /bin/bash
sudo apt install -y unzip
wget https://releases.hashicorp.com/terraform/"$tf_version"/terraform_"$tf_version"_linux_amd64.zip
unzip terraform_"$tf_version"_linux_amd64.zip"
yes
echo "move to next line"
sudo mv terraform /usr/local/bin/
rm terraform_"$tf_version"_linux_amd64.zip
