#!/usr/bin/env awk -f

function toms(val) {
  patsplit(val, _, /[ms]/, parts)
  return ((parts[0] * 60) + parts[1]) * 1000
}

/real/ { real = toms($2) }
/user/ { user = toms($2) }
/sys/  { sys  = toms($2) }

END { print real "\t" user "\t" sys }
