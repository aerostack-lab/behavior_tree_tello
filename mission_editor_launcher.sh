#!/bin/bash

NUMID_DRONE=0
export APPLICATION_PATH=${PWD}


gnome-terminal \
`#---------------------------------------------------------------------------------------------` \
`# Behavior Tree Editor                                                                        ` \
`#---------------------------------------------------------------------------------------------` \
--tab --title "Behavior Tree Editor" --command "bash -c \"
roslaunch behavior_tree_editor behavior_tree_editor.launch --wait \
  robot_namespace:=drone$NUMID_DRONE \
  drone_id:=$NUMID_DRONE \
  mission_config_path:=${APPLICATION_PATH}/configs/mission \
  catalog_path:=${APPLICATION_PATH}/configs/mission/behavior_catalog.yaml;
exec bash\""  &

