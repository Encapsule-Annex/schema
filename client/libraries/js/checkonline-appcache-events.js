
var appCacheResourceCount = 0;

var appCacheMonitor = function() {

var cache = window.applicationCache;

cache.addEventListener("cached", function () {
    $("#idBootConsoleLogo").css( { backgroundColor: "#00CCFF" } );
    Console.messageEnd("");
    Console.message("app cache: Congradulations! " + appCacheResourceCount + " resources were installed in your application cache.");
    Console.message("app cache: " + appName + " v" + appVersion + " is installed and ready for use both on and offline.");
}, false);
cache.addEventListener("checking", function () {
    $("#idBootConsoleLogo").css( { backgroundColor: "#003366"} );
    Console.message("app cache: " + appName + " v" + appVersion + " checking encapsule.org for app updates...")
}, false);
cache.addEventListener("downloading", function () {
    $("#idBootConsoleLogo").css( { backgroundColor: "#CC9900"} );
    Console.message("app cache: " + appName + " updates have been posted on encapsule.org.")
    Console.messageStart("app cache: Please wait while updates are downloaded");

}, false);
cache.addEventListener("error", function (e) {
    $("#idBootConsoleLogo").css( { backgroundColor: "#FF0000"} );
    Console.messageEnd("");
    Console.message("app cache: Unable to check for app updates at this time. Perhaps you\'re offline?");
    Console.message("app cache: Booting v" + appVersion + " app core from application cache...");
    Console.message("app cache: If network connectivity is restored during your session, we\'ll let you know.");
}, false);
cache.addEventListener("noupdate", function () {
    $("#idBootConsoleLogo").css( { backgroundColor: "#00CC00"} );
    Console.message("app cache: You have the latest version of " + appName);
    Console.message("app cache: Proceeding with v" + appVersion + " app core boot from offline app cache.");
}, false);
cache.addEventListener("progress", function () {
    $("#idBootConsoleLogo").css( { backgroundColor: "#DDAA00"} );
    appCacheResourceCount++;
    Console.messageRaw(".")
}, false);
cache.addEventListener("updateready", function () {
    // Even after swapping the cache the currently loaded page won't use it until it is reloaded, so force a reload so it is current.
    $("#idBootConsoleLogo").css( { backgroundColor: "#FFCC00"} );
    cache.swapCache();
    Console.messageEnd("");
    Console.message("app cache: Congradulations! " + appCacheResourceCount + " resources were installed in your application cache");
    Console.message("app cache: and an updated version of " + appName + " is now ready for use both on and offline.");
    Console.message("app cache: GOODBYE from v" + appVersion + " app core. Booting updated " + appName + ". BRB...");
    setTimeout((function() { return window.location.reload(true); }), 5000);

}, false);

}
