#!/bin/bash
$XML_FILE=
$CSV_FILE=
$TMP_FILE=

# Remove lines we don't want in the final output.
LINE_LIST=(proceeding reportNumber lawfirm lawfirm_sort applicant_sort dateRcpt pages regFlexAnalysis smallBusinessImpact exParte disseminated modified score fileNumber)
for ITEM in "${LINE_LIST[@]}"; do
  sed /"<arr name=\"$ITEM\">"/d f > tmpfile
  mv tmpfile f
  echo "Removing $ITEM"
done

# Remove data types.
TAG_LIST=("<str>" "<\/str>" "<long>" "<\/long>" 'arr name=\"')
for TAG in "${TAG_LIST[@]}"; do
  echo "Removing $TAG"
  sed s/"$TAG"//g $FILE > tmpfile
  mv tmpfile $FILE
done

# Cleanup removal of data types.
sed s/"\">"/">"/g $FILE > tmpfile
mv tmpfile $FILE

# Change <applicant>Aaron Couch</arr> to <applicant>Aaron Couch</applicant>
sed "s/<\(.*\)>\(.*\)\(<\/arr>\)/<\1>\2<\/\1>/g" > tmpfile
mv tmpfile $FILE

# Remove commas and parenthesis

# Export from xml file to csv
csvfix from_xml -re "doc" $XML_FILE > $CSV_FILE 
