#!/usr/bin/bash

work_dir='/home/i/github/dzintara/';
#source "${work_dir}tasks/1.sh"
source /home/i/github/dzintara/index.sh fun

#set -x
#wait_for 12 'echo $((RANDOM % 2));'
#wait_for 12 echo $RANDOM;

#line_to_add="echo source ${load_variables_file} nocd"

#add_line_to_file "/home/i/github/dzintara/test2delete/change_config_test.txt" "$line_to_add"
#mcedit "/home/i/github/dzintara/test2delete/change_config_test.txt"


fname="/home/i/github/dzintara/test2delete/change_config_test2.txt"
load_var_from_file "$fname" config
echo "$config"
#md5sum $fname


#echo -e "\n\n\n";
#cat $fname | xxd

#set -x
replace_line_by_string config "80" 'without sed=1'  '#'
#set +x
echo "$config"

fname="/home/i/github/dzintara/test2delete/change_config_test2.txt"
save_var_to_file "$fname" config

mcview "$fname"

exit 0

fname="/home/i/github/dzintara/test2delete/change_config_test.txt"
load_var_from_file "$fname" config


#md5sum $fname


#echo -e "\n\n\n";
#cat $fname | xxd

replace_line_by_string config "80" 'without sed=1'  '#'
echo "$config"

fname="/home/i/github/dzintara/test2delete/change_config_test2.txt"
save_var_to_file "$fname" config

#echo -n "$config" | xxd

#is_substr "" "1" && echo yes || echo no

exit 0

function replace_line_by_string ()
{
  #function search for strings contains substring $2 in variable, . And replace the string with $3
  #if original string contains $4 - then this string will not change
  #function use global variables to define function's behavior
  #if $1 is 'reset' - then global variables will reset to default values
  #echo -n $(( $2 < $1 ? $2 : $1 ))
  local haystack="$1";  #multiline variable, where the function will search
  local needle="$2"; #search for this substring
  local slide="$3"; #and replace sting to slide (if needle found in the string)
  local stop_word="$4"; #if stop word found in string - then this stings is untouchable
  #local xff=$(echo -n -e $'\xFF'); #delimeter with HEX code 0xFF
  #local xff='|'
  local x0a=$(echo -n -e $'\x0A'); #HEX code char
  local x0a=$(echo -n -e "\n"); #HEX code char

  if [[ "$haystack" = 'reset' ]]; then
    #if line not in file - add it in the end
    :
    return -1;
  fi;


  #find all strings with needle
  #haystack2="$(  echo -n "${haystack2}" | grep --fixed-strings --ignore-case "${needle}" )"

  #remove all strings with stop_word
  if [[ "${stop_word}" != "" ]]; then
    #haystack2="$( echo -n "${haystack2}" | grep --fixed-strings --ignore-case --invert-match "${stop_word}" )"
    :
  fi;
  #search=()
  #replace=()
  #Save old $IFS
  old_IFS="$IFS"
  #replace all strings to "$slide" with sed in loop over all lines
  #echo -n "$haystack2" | while IFS= read -r line ; do :
  haystack2=""; #output var
  while IFS= read -r line; do
    #echo -n "$haystack2" |
    #echo -n "$haystack2" | sed --expression="s${xff}${line}${xff}new${xff}g"
    #line="$(trim $line)"
    #slide="$(trim $slide)"
    #haystack3=$( echo -n "$haystack3" | sed --expression="s${xff}${line}${xff}${slide}${xff}g" );
    #haystack4="${haystack3/${line}/${slide}}"
    #haystack3="${haystack3/$line/$slide}"
    #show_var line

    #if [ is_substr "$line" "$needle" ] && [ ! is_substr "$line" "$stop_word" ]; then
    if is_substr "$line" "$needle" && ! is_substr "$line" "$stop_word" ; then
      #echo -n "YES: ";
      #show_var line needle stop_word
      #change this line to slide
      line="$slide";
    else
      #echo -n "NO: ";
      #show_var line needle stop_word
      #Don't change this line to slide
      :
    fi
    #echo -n "$line" | xxd
    #haystack2="${haystack2}${line}$'\n'";
    #IFS="$old_IFS"
    #echo -e "$line\n\n\n" | xxd
    #haystack2="$(echo -e "${haystack2}${line}${x0a}\n\n\n"; )" ;
    #haystack2+="${line}"
    #haystack2+="${x0a}${x0a}${x0a}"
    #echo -e "123\n\n\n" | xxd
    #echo "${haystack2}${line}";

    #IFS="$old_IFS"
    #line=" "
    #slide="@"
    #echo "search=[${line}], replace=[${slide}]"
    #search+=("${line}")
    #replace+=("${slide}")
    #eval_this='haystack3="${haystack3//$line/$slide}"'
    #show_var eval_this
    #eval $eval_this
    #haystack3="${haystack3//$line/$slide}" #doesnt work for me in some cases!
    #haystack3="${haystack3//$line/$slide}"

    #haystack_eval="${haystack_eval}"
    #haystack3="${haystack3//${line}/${slide}}"
    #haystack4="${haystack3//80/99}"
    #haystack3="$haystack4"
    # BASH
    #echo "s${xff}${line}${xff}new${xff}g"

    #echo -n "$haystack2" | sed --expression="s|${line}|new|g"
    #show_var line
    #done
    #vari=123123
    echo "$line"
  done <<< "$haystack"
  #show_var vari
  #show_var search replace

  #loop over array with search and replace strings
  #arraylength="${#search[@]}"
  #show_var arraylength
  #for (( i=0; i<$arraylength; i++ ));
  #do
  #  echo "index: $i, value: ${search[$i]} ${replace[$i]}"
  #done

  #haystack3="${haystack3//$v1/$v2}"
  #echo "$haystack2" | xxd
}
export -f replace_line_by_string

