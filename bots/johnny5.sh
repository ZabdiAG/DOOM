#!/bin/bash

TEMPDIR=/tmp
WORKDIR="$TEMPDIR/goose/$(date +%Y%m%d%H%M%s)"
CWD=$(pwd)
SCRIPTSDIR=${0%/*}
CMD="/usr/bin/curl -L"
RAWFILE="raw.html"
CSVFILE="form.csv"
## TODO We should extract emails from redirection or DB
OURINBOX="test@todosconsalum.tk"

## Utility functions
## Create work directory
function mkWorkdir {
  if [ ! -x $WORKDIR ] ; then
    echo -e "Create work directory\n"
    mkdir -p $WORKDIR
  fi
}

## Look for Form fileds
function lookFields {
  $SCRIPTSDIR/formparser.py $WORKDIR/$RAWFILE > $WORKDIR/$CSVFILE
}


## VARIABLE="FieldName" <-- The name attribute of the form field
function google {
  mkWorkdir
  URL="https://accounts.google.com/SignUp"
  CMD="$CMD $URL -o $WORKDIR/$RAWFILE"
  FNAME="FirstName"
  UNAME="GmailAddress"
  EMAIL="RecoveryEmailAddress"
  PASSWD="Passwd"
  SECTOK="secTok"
  ### End Common
  LNAME="LastName"
  PASSWDC="PasswdAgain"
  LOCALE="Locale"
  INPUT="Input" # BirthDay
  BMONTH="BirthMonth" # 10
  BDAY="BirthDay" # 12
  BYEAR="BirthYear" # 1978
  GENDER="Gender" # FEMALE MALE OTHER
  TOS="TermsOfService" # yes
  TIMESTAMP="timeStmp"
  DSH="dsh"
  KTL="ktl"
  _UTF8="_utf8"
  BGRESPONSE="bgresponse"
  SKIPCAPTCHA="SkipCaptcha"
  SIGNUPTOKEN="signuptoken"
  SIGNUPTOKENA="signuptoken_audio"
  SIGNUPTOKENS="signuptokenStats"
  RECAPTCHAKV="recaptchaKeyVersion"
  RECAPTCHAC="recaptcha_challenge"
  SUBMIT="Next step"
  ## Get registration form
  $CMD
  ## Process
  lookFields
}

function twitter {
  mkWorkdir
  URL="https://twitter.com/signup"
  CMD="$CMD $URL -o $WORKDIR/$RAWFILE"
  FNAME="user[name]"
  UNAME="user[screen_name]"
  EMAIL="user[email]"
  PASSWD="user[user_password]"
  SECTOK="authenticity_token"
  ## End Common
  SUIMET="signup_ui_metrics"
  ACPS="asked_cookie_personalization_setting"
  CONTEXT="context"
  AI="ad_id"
  AR="ad_ref"
  ## TODO COOKIE="user[use_cookie_personalization]"
  ##VCOOKIE="personalization"
  #VSIGNUP="signup_ui_metrics"
  #VPERSONALIZATION="asked_cookie_personalization_setting"
  #VCONTEXT="context"
  #VID="ad_id"
  #VREF="ad_ref"
  #VREMENBER="user[remember_me_on_signup]"
  #VDISCOVERABLE="user[discoverable_by_email]"
  #VSEND="user[send_email_newsletter]"

  ## Get registration form
  $CMD
  ## Process
  lookFields
}

function facebook {
  mkWorkdir
  URL="https://facebook.com"
  CMD="$CMD $URL -o $WORKDIR/$RAWFILE"
  FNAME="firstname"
  UNAME="reg_email__"

  UNAMECONF="reg_email_confirmation__"
  PASSWD="reg_passwd__"
#  PASSWDC="PasswdAgain"
  LNAME="lastname"
  LOCALE="locale"
  INPUT="Input" # BirthDay
  BMONTH="birthday_month" # 10
  BDAY="birthday_day" # 12
  BYEAR="birthday_year" # 1978
  GENDER="sex" # FEMALE MALE OTHER
#  EMAIL="RecoveryEmailAddress"
#  TOS="TermsOfService" # yes
  WEBSUBMIT="websubmit"
#  referrer="referrer"
#  asked_to_login="asked_to_login"
#  terms="terms"
#  ab_test_data="ab_test_data"
#  contactpoint_label="contactpoint_label"
#  locale="locale"
#  reg_instance="reg_instance"
#  captcha_persist_data="captcha_persist_data"
#  captcha_session="captcha_session"
#  extra_challenge_params="extra_challenge_params"
#  recaptcha_type="recaptcha_type"
#  captcha_response="captcha_response"
#  qsstamp="qsstamp"
#  lsd="lsd"

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
    ;;
  facebook)
    facebook
    ;;
  twitter)
    twitter
    ;;
  *)
    echo -e "\n\tUsage: $0 <google|facebook|twitter>\n"
    exit 1
    ;;
esac

## IMPORTANT!!!
## TODO csv2var should be the last fnuction before processing?
## Read the CSV form data and fill VVariables
function csv2var {
  while IFS=',' read -r FIELD VALUE
  do
    ## TODO Split by services
    ## Common fields
    case "$FIELD" in
      "$FNAME") VFNAME="$VALUE" ;;
      "$UNAME") VUNAME="$VALUE" ;;
      "$EMAIL") VEMAIL="$VALUE" ;;
      "$PASSWD") VPASSWD="$VALUE" ;;
      "$SECTOK") VSECTOK="$VALUE" ;; ## End Common
      "$LNAME") VLNAME="$VALUE" ;; ## Google starts
      "$PASSWDC") VPASSWDC="$VALUE" ;;
      "$LOCALE") VLOCALE="$VALUE" ;;
      "$INPUT") VINPUT="$VALUE" ;;
      "$BMONTH") VBMONTH="$VALUE" ;;
      "$BDAY") VBDAY="$VALUE" ;;
      "$BYEAR") VBYEAR="$VALUE" ;;
      "$GENDER") VGENDER="$VALUE" ;;
      "$TOS") VTOS="$VALUE" ;;
      "$TIMESTAMP") VTIMESTMP="$VALUE" ;;
      "$DSH") VDSH="$VALUE" ;;
      "$KTL") VKTL="$VALUE" ;;
      "$_UTF8") V_UTF8="$VALUE" ;;
      "$BGRESPONSE") VBGRESPONSE="$VALUE" ;;
      "$SKIPCAPTCHA") VSKIPCAPTCHA="$VALUE" ;;
      "$SIGNUPTOKEN") VSIGNUPTOKEN="$VALUE" ;;
      "$SIGNUPTOKENA") VSIGNUPTOKENA="$VALUE" ;;
      "$SIGNUPTOKENS") VSIGNUPTOKENS="$VALUE" ;;
      "$RECAPTCHAKV") VRECAPTCHAKV="$VALUE" ;;
      "$RECAPTCHAC") VRECAPTCHAC="$VALUE" ;;
      "$SUBMIT") VSUBMIT="$VALUE" ;;
    esac
    ## TODO Google only fields here
    ## Twitter only fields
    case "$FIELD" in
      "$SUIMET") VSUIMET="$VALUE" ;;
      "$ACPS") VACPS="$VALUE" ;;
      "$CONTEXT") VCONTEXT="$VALUE" ;;
      "$AI") VAI="$VALUE" ;;
      "$AR") VAR="$VALUE" ;;

    esac
  done < "$WORKDIR/$CSVFILE"
}

function setPost {
  ## multipart/form-data
  POSTDATA="\"$FNAME=$VFNAME;$LNAME=$VLNAME;$UNAME=$VUNAME"
  POSTDATA="$POSTDATA;$PASSWD=$VPASSWD;$PASSWDC=$VPASSWDC"
  POSTDATA="$POSTDATA;$LOCALE=$VLOCALE;$INPUT=$VINPUT"
  ## TODO Maybe I need an IF for different services
  ## Twitter only
  if [ $1 = 'twitter' ]; then
    POSTDATA="$POSTDATA;$SUIMET=$VSUIMET;$ACPS=$VACPS;$AI=$VAI;$AR=$VAR"
  fi
  ## Google only
  if [ $1 = 'google' ]; then
    POSTDATA="$POSTDATA;$BMONTH=$VBMONTH;$BDAY=$VBDAY"
    POSTDATA="$POSTDATA;$BYEAR=$VBYEAR;$GENDER=$VGENDER"
    POSTDATA="$POSTDATA;$EMAIL=$VEMAIL;$TOS=$VTOS"
    POSTDATA="$POSTDATA;$TIMESTAMP=$VTIMESTMP;$SECTOK=$VSECTOK"
    POSTDATA="$POSTDATA;$DSH=$VDSH;$KTL=$VKTL;$_UTF8=$V_UTF8"
    POSTDATA="$POSTDATA;$BGRESPONSE=$VBGRESPONSE"
    POSTDATA="$POSTDATA;$SKIPCAPTCHA=$VSKIPCAPTCHA;$SIGNUPTOKEN=$VSIGNUPTOKEN"
    POSTDATA="$POSTDATA;$SIGNUPTOKENA=$VSIGNUPTOKENA;$SIGNUPTOKENS=$VSIGNUPTOKENS"
    POSTDATA="$POSTDATA;$RECAPTCHAKV=$VRECAPTCHAKV;$RECAPTCHAC=$VRECAPTCHAC"
  fi
  ## Facebook only
  if [ $1 = 'facebook' ]; then
    ## TODO
    echo 'facebook'
  fi
  POSTDATA="$POSTDATA;$SUBMIT=$VSUBMIT\""
  # TODO
  echo $CMD -XPOST -F$POSTDATA
}

csv2var
setPost
## Finish him!
## TODO uncomment when finished
#rm -rf $TEMPDIR/goose
#changing
