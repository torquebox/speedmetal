# Trinidad Setup

## Write Trinidad Config File

Because of so many concurrent clients, we need to increase Trinidad's
default maxThreads from 200 to 500.

    cat << EOF > /tmp/trinidad.yml
    ---
    http:
      maxThreads: 500
    EOF

## Start Trinidad
    cd speedmetal/apps/rack/sleep/
    jruby -S trinidad -r -p 8080 -e production -t --config /tmp/trinidad.yml
