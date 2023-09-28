#!/usr/bin/env bash

PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
shopt -s nullglob

if [ $# = 0 ] ; then
  prefix=${PASSWORD_STORE_DIR-~/.password-store}
  prefix=$(readlink -f "$prefix")
  
  find $prefix -type d | sort | while read dir ; do
    [[ "$dir" =~ .git ]] && continue
    [[ "$dir" =~ docker-credential-helpers/ ]] && continue
    
    password_files=( "$dir"/*.gpg )
    password_files=( "${password_files[@]#"$prefix"/}" )
    password_files=( "${password_files[@]%.gpg}" )
    [ "${#password_files[@]}" = 0 ] && continue
    
    if [[ "$dir" = "$prefix" ]] ; then
      printf "%s\n" "${password_files[@]}"
    else
      printf -v password_files "|%s" "${password_files[@]}"
      echo "SUBMENU|${dir#$prefix/}${password_files}"
    fi
  done

else
  
  cmd="show"
  what="Password"
  
  if pass show "$1" | fgrep -q "otpauth://" ; then
    cmd="otp"
    what="OTP token"
  fi
  
  pass "$cmd" -c "$1" && echo "NOTIFICATION:$1|$what copied to clipboard"
fi
