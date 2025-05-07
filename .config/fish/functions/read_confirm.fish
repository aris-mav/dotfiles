function read_confirm --argument prompt
  while true
    read -l -P "$prompt [y/N] " confirm

    switch $confirm
      case Y y yes Yes
        return 0
      case '' N n no No
        return 1
    end
  end
end
