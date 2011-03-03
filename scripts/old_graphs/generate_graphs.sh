#!/bin/bash

latest_result() {
  find $1 -type d -depth 1 2>/dev/null | tail -n 1;
}

servers=(torquebox trinidad unicorn passenger thin)
for results_dir in `find results -type d -depth 3`; do
  command="./scripts/compare.r -o $results_dir/comparison.png"
  cmd_index=1
  for server in ${servers[@]}; do
    server_result_dir=$(latest_result "${results_dir}/${server}")
    if [ -n "$server_result_dir" ]; then
      command="${command} --dir${cmd_index} ${server_result_dir}"
    fi
    command="${command} --tag${cmd_index} ${server}"
    cmd_index=$(($cmd_index + 1))
  done
  echo $command
  echo `$command`
done
