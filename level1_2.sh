gcloud config set privateca/location us-west1
gcloud privateca pools create my-pool-1  --tier=devops
gcloud privateca pools list
gcloud privateca roots create root-1 --pool my-pool-1  --subject "CN=example Internal, O=Example ORG LLC" --location us-west1 -q;
gcloud privateca roots list
sudo apt install build-essential libssl-dev libffi-dev python3-dev cargo -y -q;
pip3 install --upgrade pip
pip3 install "cryptography>=2.2.0"
export CLOUDSDK_PYTHON_SITEPACKAGES=1
gcloud privateca certificates create \
    --issuer-pool my-pool-1 \
    --dns-san example.com \
    --generate-key \
    --key-output-file key_file \
    --cert-output-file cert_file
cat cert_file
cat key_file
openssl x509 -inform pem -in cert_file -pubkey -noout | openssl rsa -pubin -text -noout
openssl x509 -in cert_file -text -noout
gcloud privateca pools create sub-1-pool --tier=devops --location us-central1
gcloud privateca pools list
gcloud privateca subordinates create sub-ca-1 \
  --issuer-pool my-pool-1 \
  --pool sub-1-pool \
  --location us-central1 \
  --issuer-ca root-1   --issuer-location us-west1 \
  --key-algorithm "ec-p256-sha256" \
  --subject "CN=Example Internal Dev, O=Example ORG LLC" \
  --use-preset-profile "subordinate_server_tls_pathlen_0" -q;
gcloud privateca certificates create \
    --issuer-pool sub-1-pool \
    --dns-san example-dev.com \
    --generate-key \
    --issuer-location us-central1 \
    --key-output-file key_file \
    --cert-output-file cert_file;
openssl x509 -in cert_file -text -noout
