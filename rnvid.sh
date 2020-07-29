#!/data/data/com.termux/files/usr/bin/bash

# Path to unprocessed videos
path="/data/data/com.termux/files/home/downloads/clips/"

# Path to processed videos
npath="/data/data/com.termux/files/home/downloads/rnclips/"

# List of possible catagories
catagories="Short,Medium,Long,Perfect Block,Backstab,Riposte,Escape,Weapon Swap,Chain,Good Play,Funny"

# Output filename
renamed=""

function play {
  cd $path
  file=$(find *.mp4 | shuf -n 1)
  echo $file
  termux-open "${path}${file}"
  # TODO is there a better way to wait for the video to finish before continuing?
  echo "PRESS ENTER TO CONTINUE"
  read
}

function catagorise {
  res=$(termux-dialog checkbox -t "Select Catagories" -v "$catagories")
  selected=$(echo ${res} | jq -r ".values[].text")
  renamed=${renamed}${selected}
}

function comment {
  comment=$(termux-dialog text -t "Enter Comment" | jq -r ".text")
  echo "comment = ${comment}"
  if [ -n "$comment" ]; then
    renamed=${renamed}_${comment}
  fi
}

function verify {

  # Convert spaces to underscores
  renamed=$(echo $renamed | tr " " "_")

  # Add extension
  ext=$(echo $file | grep -Po "\.[^\.]+$")
  renamed=${renamed}$(echo $file | grep -Po "\.[^\.]+$")

  # Confirm filename
  res=$(termux-dialog confirm -i "${renamed}" | jq ".code")

  case $res in
    0)
      echo "Moving"
      ;;
    1)
      echo "Exiting"
      exit 0
      ;;
    *)
      echo "Verification Error"
      exit 2
      ;;
  esac

}

function move {

  testing=${renamed}
  while [[ -f "${npath}${testing}" ]]
  do
    echo "file already exists"
    testing=${renamed}$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c10)
  done
  echo $renamed
  echo $testing
  echo "mv '${path}${file}' '${npath}${testing}'"
  mv "${path}${file}" "${npath}${testing}"

}

play

# Get Option
opt=$(termux-dialog radio -t "Select Option" -v "Rename & Move,Delete,Cancel" | jq ".index")

echo $opt

case $opt in
  0)
    echo "Rename & Move"
    catagorise
    comment
    verify
    move
    #mv "${path}${file}" "${npath}${renamed}"
    # verify move?
    # crc?
    # upload?
    exit 0
    ;;
  1)
    echo "Delete"
    echo "rm '${path}${file}'"
    #rm "${path}${file:2}"
    exit 0
    ;;
  2)
    echo "Cancel"
    exit 0
    ;;
  *)
    echo "Error"
    exit 1
    ;;
esac



