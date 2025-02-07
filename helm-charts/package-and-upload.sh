#!/bin/bash

# Only the first time: 
#   Install HELM:
#     curl -o helm.tgz https://get.helm.sh/helm-v3.12.1-linux-amd64.tar.gz 
#     tar xvzf helm.tgz
#     rm helm.tgz
#     mv linux-amd64/helm /usr/local/bin/helm
#     rm -rf linux-amd64

echo "======================== PACKAGING"
for chart in helm-chart-*; do 
    # link commonHelpers
    cd $chart/templates; ln -s ../../_commonHelpers.tpl; cd ../..
    # package
    helm package $chart
    # unlink commonHelpers
    rm $chart/templates/_commonHelpers.tpl
done

#echo "======================== UPLOADING"
#echo "If error '401 unauthorized' is shown, you must login previously for the repository with: "
#echo "  helm registry login harbor.eucaim-node.i3m.upv.es"
#echo "After running the script you can logout with: "
#echo "  helm registry logout harbor.eucaim-node.i3m.upv.es"
#for chart in *.tgz; do 
#  helm push $chart oci://harbor.eucaim-node.i3m.upv.es/charts/
#done

echo "======================== Moving to local chart-catalogue"
mv -v *.tgz chart-catalogue/

echo "======================== Generating index from chart-catalogue directory"
helm repo index chart-catalogue

echo "======================== UPLOADING"
SSH_KEY=$(cat chart-catalogue-upload-ssh-key-path)
SSH_DESTINATION=$(cat chart-catalogue-upload-ssh-destination-path)
scp -i $SSH_KEY -r chart-catalogue/* $SSH_DESTINATION

