#!/usr/bin/env bash
#Constants
PREFIX="gen-cbas"
JEKYLL_SOURCE="_drafts"
JEKYLL_DESTINATION="tmp/out"

#Markdown files
INTRODUCTION="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-opt/doc/sqlpp/1_intro.md"
EXPRESSIONS="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-doc/src/main/markdown/sqlpp/2_expr.md"
QUERIES="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-doc/src/main/markdown/sqlpp/3_query.md"
ERRORS="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-doc/src/main/markdown/sqlpp/4_error.md"
DDL="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-opt/doc/sqlpp/5_ddl.md"
APPENDIX1="/Users/amarantha/cbas/asterixdb/asterixdb/asterix-opt/doc/sqlpp/appendix_1_keywords.md"

#Copy source files to local src directory
#cp $INTRODUCTION $JEKYLL_SOURCE
#cp $QUERIES $JEKYLL_SOURCE

#Build
if [[ ${1} = "build" ]]; then
	echo "Clean destination directory..."
	rm -rf $JEKYLL_DESTINATION
	
	echo "Building Jekyll..."
	jekyll serve --source "${JEKYLL_SOURCE}" --destination "${JEKYLL_DESTINATION}"

fi

exit 0



