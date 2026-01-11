function fish_right_prompt
  if test $CMD_DURATION -gt 1000
    set duration (math -s 2 $CMD_DURATION / 1000)
    echo -n "$duration"s
  else
    echo -n "$CMD_DURATION"ms
  end
end

