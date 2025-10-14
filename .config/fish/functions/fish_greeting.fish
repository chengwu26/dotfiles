function fish_greeting
  set -l blue (set_color 89B4FA)
  set -l lavender (set_color B4BEFE)
  echo -e $blue$(uptime -p | string replace 'up ' '') $lavender$(uname -r)
end
