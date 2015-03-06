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
#cd $WORKDIR
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
  TIMESTAMP="timeStmp"
  ## Get registration form
  $CMD
  ## Process
  lookFields
}


## Which service?
case "$1" in
  google)
    google
    #exit 0
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
    case "$FIELD" in
      "$FNAME") VFNAME="$VALUE" ;;
      "$LNAME") VLNAME="$VALUE" ;;
      "$UNAME") VUNAME="$VALUE" ;;
      "$PASSWD") VPASSWD="$VALUE" ;;
      "$PASSWDC") VPASSWDC="$VALUE" ;;
      "$LOCALE") VLOCALE="$VALUE" ;;
      "$INPUT") VINPUT="$VALUE" ;;
      "$BMONTH") VBMONTH="$VALUE" ;;
      "$BDAY") VBDAY="$VALUE" ;;
      "$BYEAR") VBYEAR="$VALUE" ;;
      "$GENDER") VGENDER="$VALUE" ;;
      "$EMAIL") VEMAIL="$VALUE" ;;
      "$TOS") VTOS="$VALUE" ;;
      "$TIMESTAMP") VTIMESTMP="$VALUE" ;;
    esac
  done < "$WORKDIR/$CSVFILE"
  ## Hidden fields
  VSECTOK="secTok"

}

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

csv2var
setPost
## Finish him!
## TODO uncomment when finished
#rm -rf $TEMPDIR/goose
