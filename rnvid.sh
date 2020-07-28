#!/data/data/com.termux/files/usr/bin/bash

path="/data/data/com.termux/files/home/downloads/clips/"
npath="/data/data/com.termux/files/home/downloads/rnclips/"

catagories="Short,Medium,Long,Perfect Block,Backstab,Riposte,Weapon Swap,Good Play"

renamed=""

function play {

  cd $path
  file=$(find . | shuf -n 1)
  echo $file
  termux-open "${path}${file:2}"
  read

}

function catagorise {

  res=$(termux-dialog checkbox -t "Select Catagories" -v "$catagories")
  selected=$(echo ${res} | jq -r ".values[].text")
  renamed=${renamed}${selected}
}

function comment {

  comment=$(termux-dialog text -t "Enter Comment" | jq -r ".text")
  echo $comment
  renamed=${renamed}_${comment}
}

function verify {

  # Convert to underscores
  renamed=$(echo $renamed | tr " " "_")

  # Add extension
  ext=$(echo $file | grep -Po "\.[^\.]+$")
  echo $ext

  renamed=${renamed}${ext}
  echo $renamed

  res=$(termux-dialog confirm -i "${renamed}" | jq ".code")

  case $res in
    0)
      echo "moving"
      ;;
    1)
      echo "exiting"
      ;;
    *)
      echo "err"
      ;;
  esac

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
    #mv "${path}${file}" "${npath}${renamed}
    # verify move?
    # crc?
    # upload?
    ;;
  1)
    echo "Delete"
    echo "rm '${path}${file:2}'"
    #rm "${path}${file:2}"
    ;;
  2)
    echo "Cancel"
    exit 0
    ;;
  *)
    echo "err"
    exit 1
    ;;
esac



