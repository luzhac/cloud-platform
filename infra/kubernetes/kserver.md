helm upgrade --install istio-base istio/base -n istio-system --create-namespace


helm upgrade --install istiod istio/istiod -n istio-system \
  --set pilot.resources.requests.memory=300Mi \
  --set pilot.resources.requests.cpu=200m \
  --set global.proxy.resources.requests.memory=64Mi \
  --set global.proxy.resources.requests.cpu=50m

