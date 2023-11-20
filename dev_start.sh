docker run -it \
    --name arm_build \
    --net=host \
    -e USER="faw" \
    -w /home/faw/codepath \
    -v /home/liangly/Projects/CyberRT:/home/faw/codepath \
    -d mdc-arm-ubuntu2004:v1.1 \
    /bin/bash