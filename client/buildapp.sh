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

# These identifiers should never change.

app_package_publisher="Encapsule Project"
app_package_publisher_url="http://www.encapsule.org"

app_name="Schema"
app_uuid="56611225-be91-40cf-b9b8-5c7b8a6c6f3d"

# These should be tweaked prior to deployment. Note that the appcache
# manifest contains the date stamp of the execution of this script and
# thus always ensures a appcache refresh. However, these contants should
# be refreshed in order to provide meaning to server logfiles (please).
#

app_version="0.849"
app_release_name="Gongga Shan"
app_release_fun_url="http://www.geolocation.ws/v/P/34381835/gongga-shan-seen-from-hailuogou-glacier/en"
app_version_uuid="42c28c61-da0d-4abd-9821-86e57c129239"
app_release_phase="unreleased"

app_builder_email=$*
app_build_host=`hostname`
app_builder_local=`whoami`
app_build_date=`date -u`
app_build_uuid=`uuidgen`
app_package_id="[ "$app_uuid" :: "$app_version_uuid" :: "$app_build_uuid" ]"

if [ "$app_builder" = "" ]
then
    app_builder="(local user) "$app_builder_local"@"$app_build_host
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
schema_client_app_img=$schema_client_app/img
schema_client_app_json=$schema_client_app/json
schema_client_app_nocache=$schema_client_app/no-cache

# level 3: root/deployment/client
schema_deploy_client_html=$schema_deploy_client/public_html

# level 4: /root/client/app/coffee
schema_client_app_coffee_libs=$schema_client_app_coffee/libs
schema_client_app_coffee_scdl=$schema_client_app_coffee/scdl

# level 4: root/deployment/client/public_html
schema_deploy_client_html_audio=$schema_deploy_client_html/audio
schema_deploy_client_html_css=$schema_deploy_client_html/css
schema_deploy_client_html_img=$schema_deploy_client_html/img
schema_deploy_client_html_js=$schema_deploy_client_html/js
schema_deploy_client_html_scdl=$schema_deploy_client_html/scdl
schema_deploy_client_html_nocache=$schema_deploy_client_html/no-cache

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
mkdir $schema_deploy_client_html_audio
mkdir $schema_deploy_client_html_css
mkdir $schema_deploy_client_html_img
mkdir $schema_deploy_client_html_js
mkdir $schema_deploy_client_html_scdl
mkdir $schema_deploy_client_html_nocache

cp -rv $schema_client_lib/* $schema_deploy_client_html/
cp -v $schema_client_app/*.html $schema_deploy_client_html/
cp -v $schema_client_app/.htaccess $schema_deploy_client_html/
cp -v $schema_client_app_css/*.css $schema_deploy_client_html_css/
cp -v $schema_client_app_img/*.jpg $schema_deploy_client_html_img/
cp -v $schema_client_app_img/*.png $schema_deploy_client_html_img/
cp -rv $schema_client_app_nocache/* $schema_deploy_client_html_nocache/

#### BUILD: COFFEESCRIPT COMPILE

echo schema.encapsule.org buildapp.sh: > $build_log
echo . >> $build_log
echo $y $x $t by $app_builder >> $build_log
echo . >> $build_log
echo ---
echo "// encapsule-build.js (generated)" > $build_id_js

echo "var appPackagePublisher = \""$app_package_publisher"\";" >> $build_id_js
echo "var appPackagePublisherUrl = \""$app_package_publisher_url"\";" >> $build_id_js
echo "var appPackageId = \""$app_package_id"\";" >> $build_id_js
echo "var appName = \""$app_name"\";" >> $build_id_js
echo "var appId = \""$app_uuid"\";" >> $build_id_js
echo "var appVersion = \""$app_version"\";" >> $build_id_js
echo "var appReleaseName = \""$app_release_name"\";" >> $build_id_js
echo "var appReleaseNameFunUrl = \""$app_release_fun_url"\";" >> $build_id_js
echo "var appReleaseId = \""$app_version_uuid"\";" >> $build_id_js
echo "var appReleasePhase = \""$app_release_phase"\";" >> $build_id_js
echo "var appBuildId = \""$app_build_uuid"\";" >> $build_id_js
echo "var appBuilder = \""$app_builder_email"\";" >> $build_id_js
echo "var appBuildTime = \""$app_build_date"\";" >> $build_id_js
echo "var appCacheManifestUrl = \"schema.appcache\";" >> $build_id_js
echo "var appCopyright = \"2013 Encapsule Project\";" >> $build_id_js
echo "var appLicense = \"Boost Software License v1.0\";" >> $build_id_js
echo "var appLicenseUrl = \"http://www.boost.org/LICENSE_1_0.txt\";" >> $build_id_js
echo "var appGitHubRepoName = \"encapsule/schema\";" >> $build_id_js
echo "var appGitHubRepoUrl = \"https://github.com/Encapsule/schema\";" >> $build_id_js
echo "var appBlogName = \"Encapsule Project Blog\";" >> $build_id_js
echo "var appBlogUrl = \"http://blog.encapsule.org\";" >> $build_id_js

rebuild=1
while [ $rebuild -eq 1 ]
do
echo =================================================================
echo =================================================================
echo =================================================================
echo === v--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo Building application Coffeescript libraries:
cd $schema_client_app_coffee
coffee -o $schema_deploy_client_html_js/ -c *.coffee
cd $schema_client_app_coffee_scdl
# cat *.coffee > encapsule-lib-scdl.coffee
# coffee -o $schema_deploy_client_html_js/ -c encapsule-scdl.coffee
coffee -o $schema_deploy_client_html_js/ -c *.coffee
cd $schema_client_app_coffee_libs
coffee -o $schema_deploy_client_html_js/ -c *.coffee
echo === ^--- COFFEESCRIPT: EXPECT NO ERRORS =========================
echo =================================================================
echo =================================================================
echo =================================================================

if [ "$1" = "loop" ]
then
    echo -n 0..
    sleep 1
    echo -n 1..
    sleep 1
    echo -n 2..
    sleep 1
    echo -n 3..
    sleep 1
    echo -n 4..
    sleep 1
    echo rebuild
    sleep 1
    clear
else
    rebuild=0
    if [ "$1" = "pause" ]
    then
        echo -n 'PAUSED. Hit ENTER to complete the build. > ' ; read USERINPUT
    fi
fi
done



echo Deployed Javascripts:
ls -lRat $schema_deploy_client

echo Build complete. Generated output listing: >> $build_log
echo . >> $build_log

ls -lRat $schema_deploy_client >> $build_log
echo --- >> $build_log

cd $schema_deploy_client_html
appCache=`find *.html css/*.css js/*.js audio/*.wav audio/*.mp3 scdl/*.json json/*.json img/*.jpg img/*.png -type f`
echo APP CACHE:
echo $appCache
echo .
echo $appCache | sort -k3,3

echo CACHE MANIFEST > $build_appcache_manifest
echo "# Package ID: "$app_package_id  >> $build_appcache_manifest
echo "# Package Detail: "$app_name" v"$app_version" tag=\""$app_release_name"\" built "$app_build_date" by "$app_builder >> $build_appcache_manifest
echo "#" >> $build_appcache_manifest
echo "# These files will be cached for offline use by the app." >> $build_appcache_manifest
count=0
for x in $appCache
do
    cacheFilename=`echo $x | sed -e 's/\.\//\//'`
    echo $cacheFilename
    if [ "$cacheFilename" != "/.htaccess" ] && [ "`echo $cacheFilename | grep .gitignore`" = "" ] && [ "`echo $cacheFilename | grep .directory`" = "" ]
    then
       echo $cacheFilename >> $build_appcache_manifest
       count=$((count + 1))
    else
       echo SKIPPED!
    fi
done
echo Total files in the cache: $count
echo "var appBuildCacheFileCount = "$count";" >> $build_id_js
echo "# These files require server access." >> $build_appcache_manifest
echo "NETWORK:" >> $build_appcache_manifest
echo 'no-cache/json/client-ping.json' >> $build_appcache_manifest
echo "# Map failed requests for online resources." >> $build_appcache_manifest
echo "FALLBACK:" >> $build_appcache_manifest
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
