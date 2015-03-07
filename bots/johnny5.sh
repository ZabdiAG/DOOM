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
function facebook{
  mkWorkdir
  URL="https://facebook.com"
  CMD="$CMD $URL -o $WORKDIR/$RAWFILE"
  ## Form fields
  FNAME="firstname"
  LNAME="lastname"
  UNAME="reg_email__"
  UNAMECONF="reg_email_confirmation__"
  PASSWD="reg_passwd__"
#  PASSWDC="PasswdAgain"
  LOCALE="locale"
  INPUT="Input" # BirthDay
  BMONTH="birthday_month" # 10
  BDAY="birthday_day" # 12
  BYEAR="birthday_year" # 1978
  GENDER="sex" # FEMALE MALE OTHER
#  EMAIL="RecoveryEmailAddress"
#  TOS="TermsOfService" # yes
  WEBSUBMIT="websubmit"
  referrer="referrer"
  asked_to_login="asked_to_login"
  terms="terms"
  ab_test_data="ab_test_data"
  contactpoint_label="contactpoint_label"
  locale="locale"
  reg_instance="reg_instance"
  captcha_persist_data="captcha_persist_data"
  captcha_session="captcha_session"
  extra_challenge_params="extra_challenge_params"
  recaptcha_type="recaptcha_type"
  captcha_response="captcha_response"
  qsstamp="qsstamp"
  lsd="lsd"

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
