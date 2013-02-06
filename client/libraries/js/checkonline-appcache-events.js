

var appCacheMonitor = function() {

var cache = window.applicationCache;

cache.addEventListener("cached", function () {
    console.log("schema appcache: All resources for this web app have now been downloaded. You can run this application while not connected to the internet");
}, false);
cache.addEventListener("checking", function () {
    console.log("schema appcache: Checking manifest");
}, false);
cache.addEventListener("downloading", function () {
    console.log("schema appcache: Starting download of cached files");
}, false);
cache.addEventListener("error", function (e) {
    console.log("schema appcache: There was an error in the manifest, downloading cached files or you're offline: " + e);
}, false);
cache.addEventListener("noupdate", function () {
    console.log("schema appache: There was no update needed");
}, false);
cache.addEventListener("progress", function () {
    console.log("schema appcache: Downloading cached files");
}, false);
cache.addEventListener("updateready", function () {
    cache.swapCache();
    console.log("schema appache: Updated cache is ready");
    // Even after swapping the cache the currently loaded page won't use it
    // until it is reloaded, so force a reload so it is current.
    window.location.reload(true);
    console.log("schema appcache: WINDOW RELOADED!");
}, false);

}
