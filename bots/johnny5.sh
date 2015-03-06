#!/bin/bash
TEMPDIR=/tmp
WORKDIR="$TEMPDIR/goose/$(date +%Y%m%d%H%M%s)"
CWD=$(pwd)
CMD="/usr/bin/curl -L"
RAWFILE="raw.html"
## TODO We should extract emails from redirection or DB
OURINBOX="test@todosconsalum.tk"

## Utility functions
## Create work directory
function mkWorkdir {
  if [ ! -x $WORKDIR ] ; then
    echo -e "Create work directory\n"
    mkdir -p $WORKDIR
  fi
#cd $WORKDIR
}

## Look for Form fileds
function lookFields {
  grep -E -e '<input*' -e '*/input>' -e '<form.*>' \
    --color \
    $WORKDIR/$RAWFILE
}

## VARIABLE="FieldName" <-- The name attribute of the form field
function google {
  mkWorkdir
  URL="https://accounts.google.com/SignUp"
  CMD="$CMD $URL -o $WORKDIR/$RAWFILE"
  ## Form fields
  FNAME="FirstName"
  LNAME="LastName"
  UNAME="GmailAddress"
  PASSWD="Passwd"
  PASSWDC="PasswdAgain"
  LOCALE="Locale"
  INPUT="Input" # BirthDay
  BMONTH="BirthMonth" # 10
  BDAY="BirthDay" # 12
  BYEAR="BirthYear" # 1978
  GENDER="Gender" # FEMALE MALE OTHER
  EMAIL="RecoveryEmailAddress"
  TOS="TermsOfService" # yes
  # Form VALUES
  VFNAME="FirstName"
  VLNAME="LastName"
  VUNAME="GmailAddress"
  VPASSWD="Passwd"
  VPASSWDC="PasswdAgain"
  VLOCALE="es"
  VINPUT="BirthDay"
  VBMONTH="10"
  VBDAY="12"
  VBYEAR="1978"
  VGENDER="OTHER" # FEMALE MALE OTHER
  VEMAIL="$OURINBOX"
  VTOS="yes" # yes
  ## Hidden fields
  VTIMESTMP="timeStmp"
  VSECTOK="secTok"
  ## Get registration form
  $CMD
  ## Process
  lookFields
}

## Which service?
case "$1" in
  google)
    google
    exit 0
    ;;
  *)
    echo -e "\n\tUsage: $0 <google|facebook|twitter>\n"
    exit 1
    ;;
esac

function setPost {
  ## multipart/form-data
  POSTDATA="\"$FNAME=$VFNAME;$LNAME=$VLNAME;$UNAME=$VUNAME"
  POSTDATA="$POSTDATA;$PASSWD=$VPASSWD;$PASSWDC=$VPASSWDC"
  POSTDATA="$POSTDATA;$LOCALE=$VLOCALE;$INPUT=$VINPUT"
  ## TODO Maybe I need an IF for different services
  POSTDATA="$POSTDATA;$BMONTH=$VBMONTH;$BDAY=$VBDAY"
  POSTDATA="$POSTDATA;$BYEAR=$VBYEAR;$GENDER=$VGENDER"
  POSTDATA="$POSTDATA;$EMAIL=$VEMAIL;$TOS=$VTOS\""
  # TODO 
  echo $CMD -XPOST -F$POSTDATA
}


## Finish him!
## TODO uncomment when finished
#rm -rf $TEMPDIR/goose
#changing
