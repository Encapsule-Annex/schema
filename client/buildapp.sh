#! /bin/sh
#
# This will need to become a makefile before too long.
#

clear
echo Building schema.encapsule.org deployment package...
echo -----------------------------------------------------------------

current_dir=`cd`

app_name=schema.encapsule.org
app_release_version="<0"
app_release_name=prerelease
app_builder=$*
x=`hostname`
y=`whoami`
t=`date -u`

# Declarations: customize for local repo

# level 0
schema_repo=~/Code/schema
cd $schema_repo ; pwd

# level 1 : root/
schema_client=$schema_repo/client
schema_deploy=$schema_repo/deployment
schema_server=$schema_repo/server

# level 2 : root/client/

schema_client_lib=$schema_client/libraries
schema_client_app=$schema_client/app

# level 2: root/deployment/

schema_deploy_client=$schema_deploy/client
schema_deploy_data=$schema_deploy/data
schema_deploy_server=$schema_deploy/server

# level 3: root/deployment/client

schema_deploy_client_html=$schema_deploy_client/public_html

# level 4: root/deployment/client/public_html

schema_deploy_client_html_css=$schema_deploy_client_html/css
schema_deploy_client_html_js=$schema_deploy_client_html/js

# Special files (e.g. build logs)

build_log=$schema_deploy_client/build.log
build_id_js=$schema_deploy_client_html_js/encapsule-build.js

#### BUILD: CLEAN

set | grep schema
echo App builder e-mail specified on command line: $app_builder

echo -----------------------------------------------------------------
cd $schema_repo
echo Creating directories...

rm -rfv $schema_deploy_client_html/*
echo $schema_deploy_client_html
mkdir $schema_deploy_client_html

cp -rv $schema_client_lib/* $schema_deploy_client_html/
cp -v $schema_client_app/*.html $schema_deploy_client_html/
cp -v $schema_client_app/.htaccess $schema_deploy_client_html/
cp -v $schema_client_app/*.css $schema_deploy_client_html_css/

#### BUILD: COFFEESCRIPT COMPILE

echo schema.encapsule.org buildapp.sh: > $build_log
echo . >> $build_log
echo $y $x $t by $app_builder >> $build_log
echo . >> $build_log
echo ---
echo "// encapsule-build.js (generated)" > $build_id_js
echo "var appName = \""$app_name"\";" >> $build_id_js
echo "var appReleaseVersion = \""$app_release_version"\";" >> $build_id_js
echo "var appReleaseName = \""$app_release_name"\";" >> $build_id_js
echo "var appBuildTime = \""$t"\";" >> $build_id_js
echo "var appBuilder = \""$app_builder"\";" >> $build_id_js
echo "var appBuilderHost = \"trickster\";" >> $build_id_js

cd $schema_client_app
echo =================================================================
echo === v--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo Building application Coffeescript libraries:
coffee -o $schema_deploy_client_html_js/ -c *.coffee
echo === ^--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo =================================================================
echo Generated JS resources: `ls $client_output_js`

echo Build complete. Generated output listing: >> $build_log
echo . >> $build_log

ls -lRat $schema_deploy_client >> $build_log
echo --- >> $build_log

#### BUILD: COMPLETE

cd $current_dir

#echo Generated build output:
#ls -lRat $schema_deploy_client

echo -----------------------------------------------------------------
echo Build complete. Logfile: $build_log
echo .
