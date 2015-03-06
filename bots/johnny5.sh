#!/bin/env bash

TEMPDIR=/tmp
WORKDIR="$TEMPDIR/goose/$(date +%Y%m%d%H%M%s)"
CWD=$(pwd)
CMD="/usr/bin/curl -L"
RAWFILE="raw.html"
## TODO We should extract emails from redirection or DB
OURINBOX="test@todosconsalum.tk"

## Utility functions
## Look for Form fileds
function lookFields {
  grep -E -e '<input*' -e '*/input>' -e '<form.*>' \
    --color \
    $WORKDIR/$RAWFILE
}

## VARIABLE="FieldName" <-- The name attribute of the form field
function google {
  URL="https://accounts.google.com/SignUp"
  #CGET="$URL -o $WORKDIR/$RAWFILE"
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

  $CMD
}


if [ ! -x $WORKDIR ] ; then
  echo -e "Create work directory\n"
  mkdir -p $WORKDIR
fi
cd $WORKDIR

## Which service?
case "$1" in
  google)   google
    ;;
  *)
    echo "Invalid!"
    ;;
esac
## multipart/form-data
POSTDATA="\"$FNAME=$VFNAME;$LNAME=$VLNAME;$UNAME=$VUNAME"
POSTDATA="$POSTDATA;$PASSWD=$VPASSWD;$PASSWDC=$VPASSWDC"
POSTDATA="$POSTDATA;$LOCALE=$VLOCALE;$INPUT=$VINPUT"
## TODO Maybe I need an IF for different services
POSTDATA="$POSTDATA;$BMONTH=$VBMONTH;$BDAY=$VBDAY"
POSTDATA="$POSTDATA;$BYEAR=$VBYEAR;$GENDER=$VGENDER"
POSTDATA="$POSTDATA;$EMAIL=$VEMAIL;$TOS=$VTOS\""


## Process
#$CMD $CGET
echo $CMD -XPOST -F$POSTDATA
lookFields

## Finish him!
#rm -rf $TEMPDIR/goose
