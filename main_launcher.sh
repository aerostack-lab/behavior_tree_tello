#!/bin/bash

NUMID_DRONE=0
export APPLICATION_PATH=${PWD}


#---------------------------------------------------------------------------------------------
# INTERNAL PROCESSES
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# Basic Behaviors                                                                             ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Basic Behaviors" --command "bash -c \"
roslaunch basic_quadrotor_behaviors basic_quadrotor_behaviors.launch --wait \
    namespace:=drone$NUMID_DRONE;
exec bash\"" \
`#---------------------------------------------------------------------------------------------` \
`# Quadrotor Motion With Platform Control                                                           ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Quadrotor Motion With Platform Control" --command "bash -c \"
roslaunch quadrotor_motion_with_platform_control quadrotor_motion_with_platform_control.launch --wait \
    namespace:=drone$NUMID_DRONE;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# TELLO INTERFACE                                                                             ` \
`#---------------------------------------------------------------------------------------------` \
  --tab --title "Tello Interface" --command "bash -c \"
roslaunch tello_interface_process tello_interface.launch --wait \
    drone_namespace:=drone$NUMID_DRONE;
  exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Multi sensor fusion behaviors                                                               ` \
`#---------------------------------------------------------------------------------------------` \
  --tab --title "Multi sensor fusion behaviors" --command "bash -c \"
roslaunch multi_sensor_fusion multi_sensor_fusion.launch  --wait \
    namespace:=drone$NUMID_DRONE;
  exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Execution Viewer                                                                   ` \
`#---------------------------------------------------------------------------------------------` \

`#---------------------------------------------------------------------------------------------` \
`# Belief Manager                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief Manager" --command "bash -c \"
roslaunch belief_manager_process belief_manager_process.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    drone_id:=$NUMID_DRONE \
    config_path:=${APPLICATION_PATH}/configs/mission;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Belief Updater                                                                              ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Belief Updater" --command "bash -c \"
roslaunch belief_updater_process belief_updater_process.launch --wait \
    drone_id_namespace:=drone$NUMID_DRONE \
    drone_id:=$NUMID_DRONE;
exec bash\""  \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Coordinator                                                                       ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior coordinator" --command "bash -c \" sleep 2;
roslaunch behavior_coordinator behavior_coordinator.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  catalog_path:=${APPLICATION_PATH}/configs/mission/behavior_catalog.yaml;
exec bash\""  &

echo "- Waiting for all process to be started..."
# wait for the modules to be running
sleep 3

#---------------------------------------------------------------------------------------------
# SHELL INTERFACE
#---------------------------------------------------------------------------------------------
gnome-terminal  \
`#---------------------------------------------------------------------------------------------` \
`# alphanumeric_viewer                                                                         ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "alphanumeric_viewer"  --command "bash -c \"
roslaunch alphanumeric_viewer alphanumeric_viewer.launch --wait \
  drone_id_namespace:=drone$NUMID_DRONE;
exec bash\""  &

gnome-terminal \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Tree Interpreter                                                                   ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior Tree Interpreter" --command "bash -c \"
roslaunch behavior_tree_interpreter behavior_tree_interpreter.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE \
  mission_configuration_folder:=${APPLICATION_PATH}/configs/mission \
  catalog_path:=${APPLICATION_PATH}/configs/mission/behavior_catalog.yaml;
exec bash\"" &


rqt_image_view /drone0/sensor_measurement/camera
