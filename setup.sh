#!/usr/bin/sh
_SETUP_PATH=$(cd `dirname $BASH_SOURCE[0]`; pwd)
echo $_SETUP_PATH
LD_LIBRARY_PATH=$_SETUP_PATH/lib:$LD_LIBRARY_PATH
PATH=$_SETUP_PATH/bin/cyber/tools:$_SETUP_PATH/bin/cyber/mainboard:$PATH
CYBER_PATH=$_SETUP_PATH/share/
export PATH LD_LIBRARY_PATH CYBER_PATH

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
