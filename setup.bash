#!/usr/bin/bash

_SETUP_PATH=$(cd `dirname $BASH_SOURCE[0]`; pwd)

CYBERRT_PATH=$(dirname "$_SETUP_PATH")
BUILD_PATH=$_SETUP_PATH
PATH=$_SETUP_PATH/bin/cyber/tools:$_SETUP_PATH/bin/cyber/mainboard:$PATH
PYTHONPATH=$_SETUP_PATH/lib/python/site-packages:$PYTHONPATH
LD_LIBRARY_PATH=$_SETUP_PATH/lib:$LD_LIBRARY_PATH
LIBRARY_PATH=$_SETUP_PATH/lib:$LIBRARY_PATH
CMAKE_PREFIX_PATH=$_SETUP_PATH:$CMAKE_PREFIX_PATH
PKG_CONFIG_PATH=$_SETUP_PATH/lib/pkgconfig:$_SETUP_PATH/share/pkgconfig:$PKG_CONFIG_PATH
CYBER_PATH=$_SETUP_PATH/share/
export PATH LD_LIBRARY_PATH CMAKE_PREFIX_PATH PKG_CONFIG_PATH PYTHONPATH CYBER_PATH

bazel_bin_path="${BUILD_PATH}/bin"
mainboard_path="${bazel_bin_path}/cyber/mainboard"
cyber_tool_path="${bazel_bin_path}/cyber/tools"
recorder_path="${cyber_tool_path}/cyber_recorder"
launch_path="${cyber_tool_path}/cyber_launch"
channel_path="${cyber_tool_path}/cyber_channel"
node_path="${cyber_tool_path}/cyber_node"
service_path="${cyber_tool_path}/cyber_service"
monitor_path="${cyber_tool_path}/cyber_monitor"
visualizer_path="${bazel_bin_path}/modules/tools/visualizer"

for entry in "${mainboard_path}" \
    "${recorder_path}" "${monitor_path}"  \
    "${channel_path}" "${node_path}" \
    "${service_path}" \
    "${launch_path}" \
    "${visualizer_path}" ; do
    export PATH="${entry}":$PATH
done

export GLOG_alsologtostderr=1
export GLOG_colorlogtostderr=1
export GLOG_minloglevel=0
export sysmo_start=0
export CYBER_DOMAIN_ID=80
export CYBER_IP=127.0.0.1
