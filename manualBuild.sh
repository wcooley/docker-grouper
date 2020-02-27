docker build --pull --tag=itap/grouper:latest . \

if [[ "$OSTYPE" == "darwin"* ]]; then
  say build complete
fi
