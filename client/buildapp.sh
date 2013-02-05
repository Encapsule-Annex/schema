#! /bin/sh
#
# This will need to become a makefile before too long.
#

clear
echo Building schema.encapsule.org deployment package...
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------

app_name=schema.encapsule.org
app_release_version="<0"
app_release_name=prerelease
app_builder=$*
x=`hostname`
y=`whoami`
t=`date -u`
echo $x $y $t
if [ "$app_builder" = "" ]
then
    app_builder="(local user) "$y"@"$x
fi

# Declarations: customize for local repo

# level 0
schema_repo=~/Code/schema
current_dir=`cd`
cd $schema_repo
pwd

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

# level 3: root/client/app
schema_client_app_css=$schema_client_app/css
schema_client_app_coffee=$schema_client_app/coffee

# level 3: root/deployment/client

schema_deploy_client_html=$schema_deploy_client/public_html

# level 4: root/deployment/client/public_html

schema_deploy_client_html_css=$schema_deploy_client_html/css
schema_deploy_client_html_js=$schema_deploy_client_html/js
schema_deploy_client_html_img=$schema_deploy_client_html/img
schema_deploy_client_html_audio=$schema_deploy_client_html/audio
schema_deploy_client_html_scdl=$schema_deploy_client_html/scdl

# Special files (e.g. build logs)

build_log=$schema_deploy_client/build.log
build_id_js=$schema_deploy_client_html_js/encapsule-build.js
build_appcache_manifest=$schema_deploy_client_html/schema.appcache

#### BUILD: CLEAN

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
cp -v $schema_client_app_css/*.css $schema_deploy_client_html_css/

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

cd $schema_client_app_coffee
echo =================================================================
echo =================================================================
echo =================================================================
echo === v--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo Building application Coffeescript libraries:
coffee -o $schema_deploy_client_html_js/ -c *.coffee
echo === ^--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo =================================================================
echo =================================================================
echo =================================================================
echo Deployed Javascripts:
ls -lRat $schema_deploy_client

echo Build complete. Generated output listing: >> $build_log
echo . >> $build_log

ls -lRat $schema_deploy_client >> $build_log
echo --- >> $build_log

cd $schema_deploy_client_html
appCache=`find *.html css/*.css js/*.js audio/*.wav scdl/*.json -type f`
echo APP CACHE:
echo $appCache
echo .
echo $appCache | sort -k3,3

echo CACHE MANIFEST > $build_appcache_manifest
echo "# "$app_name "v"$app_release_version "("$app_release_name")" >> $build_appcache_manifest
echo "# Built "$t" by "$app_builder >> $build_appcache_manifest
echo "#" >> $build_appcache_manifest
echo "# These files will be cached for offline use by the app." >> $build_appcache_manifest
for x in $appCache
do
    cacheFilename=`echo $x | sed -e 's/\.\//\//'`
    echo $cacheFilename
    if [ "$cacheFilename" != "/.htaccess" ] && [ "`echo $cacheFilename | grep .gitignore`" = "" ] && [ "`echo $cacheFilename | grep .directory`" = "" ]
    then
       echo $cacheFilename >> $build_appcache_manifest
    else
       echo SKIPPED!
    fi
done
echo "#" >> $build_appcache_manifest
echo "# These files require server access." >> $build_appcache_manifest
echo "NETWORK:" >> $build_appcache_manifest
echo "#" >> $build_appcache_manifest
echo "# Map failed requests for online resources." >> $build_appcache_manifest
echo "NETWORK:" >> $build_appcache_manifest
echo "#" >> $build_appcache_manifest
echo "# EOM" >> $build_appcache_manifest

echo Wrote application cache manifest to $build_appcache_manifest





#### BUILD: COMPLETE

cd $current_dir

#echo Generated build output:
#ls -lRat $schema_deploy_client

echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo -----------------------------------------------------------------
echo Build complete. Logfile: $build_log
echo .
