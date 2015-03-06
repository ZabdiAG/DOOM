#!/bin/env bash

URL="$1"
TEMPDIR=/tmp
WORKDIR="$TEMPDIR/goose/$(date +%Y%m%d%H%M%s)"
CWD=$(pwd)
CMD="/usr/bin/curl"
CGET="$URL -o $WORKDIR/raw.html"

## VARIABLE="FieldName" <-- The name attribute of the form field
# Google
FNAME="FirstName"
LNAME="LastName"
UNAME="GmailAddress"
PASSWD="Passwd"
PASSWDC="PasswdAgain"
LOCALE="es"
INPUT="Input" # BirthDay
BMONTH="BirthMonth" # 10
BDAY="BirthDay" # 12
BYEAR="BirthYear" # 1978
GENDER="Gender" # FEMALE MALE OTHER
EMAIL="RecoveryEmailAddress"
TOS="TermsOfService" # yes
# VALUES
FNAME="FirstName"
LNAME="LastName"
UNAME="GmailAddress"
PASSWD="Passwd"
PASSWDC="PasswdAgain"
LOCALE="es"
INPUT="Input" # BirthDay
BMONTH="BirthMonth" # 10
BDAY="BirthDay" # 12
BYEAR="BirthYear" # 1978
GENDER="Gender" # FEMALE MALE OTHER
EMAIL="RecoveryEmailAddress"
TOS="TermsOfService" # yes



if [ ! -x $WORKDIR ] ; then
  echo -e "Create work directory\n"
  mkdir -p $WORKDIR
fi
cd $WORKDIR

## multipart/form-data
POSTDATA="\"$FNAME=$VFNAME;$LNAME=$VLNAME;$UNAME=$VUNAME"
POSTDATA="$POSTDATA;$PASSWD=$VPASSWD;$PASSWDC=$VPASSWDC"
POSTDATA="$POSTDATA;$LOCALE=$VLOCALE;$INPUT=$VINPUT"
## TODO Maybe I need an IF for different services
POSTDATA="$POSTDATA;$BMONTH=$VBMONTH;$BDAY=$VBDAY"
POSTDATA="$POSTDATA;$BYEAR=$VBYEAR;$GENDER=$VGENDER"
POSTDATA="$POSTDATA;$EMAIL=$VEMAIL;$TOS=$VTOS\""

## 1. Initial GET request
echo $CMD $CGET
echo
echo $CMD -XPOST -F$POSTDATA

