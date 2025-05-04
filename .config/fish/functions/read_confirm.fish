function read_confirm
  while true
    read -l -P 'Do you want to continue? [y/N] ' confirm

    switch $confirm
      case Y y yes Yes
        return 0
      case '' N n no No
        return 1
    end
  end
end
