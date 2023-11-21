docker run -it \
    --name arm_build \
    --net=host \
    -e USER="faw" \
    -w /home/faw/codepath \
    -v /home/liangly/Projects/CyberRT:/home/faw/codepath \
    -v /dev:/dev \
    -d mdc-arm-ubuntu2004:v1.2 \
    /bin/bash