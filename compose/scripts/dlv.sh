while true; do
    /compose/bin/dlv exec --headless --listen=:2345 --api-version=2 $@
done
