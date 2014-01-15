#!/bin/bash
# 
# Database Scan Script 
# Author: Hrishikesh Mishra
# Copyright: Fabfurnish @2014
#

MYSQL_USER='<mysql_user>'
MYSQL_DB='<mysql_database>'
DATE_TIME=`date`

echo "=====================================================================\n"
echo "***************        Welcome to DB scan             ***************\n"
echo "=====================================================================\n"
echo "|  Database:  $MYSQL_DB                                              |\n" 
echo "|  User:      $MYSQL_USER                                            |\n" 
echo "|  Date:      $DATE_TIME                                             |\n" 
echo "---------------------------------------------------------------------\n"
echo "---------------       Table Scan Started               --------------\n"
echo "---------------------------------------------------------------------\n"

ALL_TABLE=`mysql -u $MYSQL_USER $MYSQL_DB -Bse 'SHOW TABLES'`
TOTAL_TABLE=0

for T in $ALL_TABLE
do 
    TOTAL_TABLE=`expr $TOTAL_TABLE + 1`
    
    COLUMN_QUERY='SELECT COUNT(*)  FROM  INFORMATION_SCHEMA.COLUMNS WHERE  table_name = "'$T'" AND  TABLE_SCHEMA = "'$MYSQL_DB'"'
    COLUMN_COUNT=`mysql -u $MYSQL_USER $MYSQL_DB -Bse "$COLUMN_QUERY"`
    
    RECORD_QUERY='SELECT COUNT(*) FROM '$T
    RECORD_COUNT=`mysql -u $MYSQL_USER $MYSQL_DB -Bse "$RECORD_QUERY"`
    
    INDEX_QUERY='SHOW INDEX FROM '$T' FROM '$MYSQL_DB
    INDEX_COUNT=`mysql -u $MYSQL_USER  -te  "$INDEX_QUERY"`
    
   echo "|  Table:  $T                                                   |\n" 
   echo "|  Total Columns:  $COLUMN_COUNT                                |\n" 
   echo "|  Total Records:  $RECORD_COUNT                                |\n" 
   echo "|  Index Detail:                                                 |\n" 
    
   echo $INDEX_COUNT;  
 
done



echo "---------------------------------------------------------------------\n"
echo "---------------       Table Scan Completed            --------------\n"
echo "---------------------------------------------------------------------\n"
echo "|  Total Table:  $TOTAL_TABLE                                        |\n" 
echo "---------------------------------------------------------------------\n"

DB_QUERY='SELECT TABLE_NAME AS "Table",TABLE_ROWS AS "Rows", DATA_LENGTH AS "Data Size", INDEX_LENGTH AS "Index Size", (DATA_LENGTH+ INDEX_LENGTH) AS "Total Size",TRIM(TRAILING ", " FROM CONCAT_WS(", ", ENGINE, TABLE_COLLATION, CREATE_OPTIONS)) AS  "Type" FROM information_schema.TABLES WHERE information_schema.TABLES.table_schema = "'$MYSQL_DB'"'
DB_SUMMARY=`mysql -u $MYSQL_USER -te "$DB_QUERY"`

echo "---------------------------------------------------------------------\n"
echo "---------------------------------------------------------------------\n"
echo "---------------       Table Summary                    --------------\n"
echo "---------------------------------------------------------------------\n"
echo $DB_SUMMARY
echo "---------------------------------------------------------------------\n"
echo "---------------       Thank you, DB scan completed     --------------\n"
echo "---------------------------------------------------------------------\n"
