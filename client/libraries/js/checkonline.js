/* welcome to a js lib with markdown in a block comment:
# Am I online?
```javascript
checkOnline(function(online) {
  if (online) {
    //yay!
  } else {
    //offline boo :(
  }
});
```

Subscribe to online/offline events:
```javascript
var $window = $(window);
$window.on('offline', function nowOffline() {});
$window.on('online', function nowOnline() {});
```

https://github.com/devinrhode2/check-online MIT license

Originally by Rob: http://ednortonengineeringsociety.blogspot.com/2010/10/detecting-offline-status-in-html-5.html<br>

The first argument is your result callback.

The second argument is 

When you're working with a jQuery ajax failure, you can pass the fail callback `arguments`<br>
as a second parameter to check offline, to potentially short circuit the operation<br>
- if the failure looks like it was from being offline, we'll double check you're offline<br>
- if the args describe an ajax or other error, you're online (therefore, you might want to track and report this ajax error)<br>
- if you omit this second arg, things work just as expected.<br>

!IMPORTANT expects /onlineCheck.json to contain just 'online'<br>
Your server also needs to support filename based cache busting, which html5 boilerplate's .htaccess file has for you<br>
but you will need to add json to the list of file extensions list.<br>

2013.02.06 ChrisRus: I'm hacking this up a little to help me integrate into the schema.encapsule.org application.
Primarily I'm interested in making this library a bit more customizable. Rather than explode the checkOnline parameter
list, I'm replacing the resultCallback parameter with a generic options object from which we'll cherry pick the
parameters we know about (or use internal default values).<br>

```javascript
 */
var checkOnline = function checkOnlineF(resultCallback, options_, jQueryXhrFailArgs) {
  'use strict';
  if (navigator.onLine) {
    
    //if no jQueryXhrFailArgs, nothing happens.
    if (jQueryXhrFailArgs != null) { //compare to null because maybe it's some other falsey value..
      var arg = [].slice.call(jQueryXhrFailArgs, 0); //in case you pass in the vanilla `arguments`
      
      if (!arg[3]) {
        arg[3] = arg[0].getAllResponseHeaders(); //if we got no response we should have no response headers
        //so this is expected to be the empty string
      }
      
      //If we have all these exact args and no headers, it's very likely we're offline.
      //-Otherwise, we have an explcit ajax error
      //If this proves fragile, then this if level can be removed, and the else branch deleted.
      if (arg[0].responseText !== 0  ||
          arg[0].status       !== 0  ||
          arg[0].readyState   !== '' ||
          arg[0].statusText   !== 'error' ||
          arg[1]              !== 'error' ||
          arg[2] !== '' ||
          arg[3] !== ''//result from .getAllResponseHeaders(). We should have no response headers, because we didn't get a response
         )
         //else if jQueryFailArgs differ from the above, there's some ajax error that isn't EXACTLY the error args from being offline.
      {
        console.log('checkOnline thinks these args describe an ajax failure (and you\'re online):' +
                    '\n' + JSON.stringify(arg) +
                    '\ncheckOnline reads these args as a failure from being offline:' +
                    '\n[{"responseText":0,"status":0,"readyState":"","statusText":"error"},"error","",""]');
        resultCallback(false);
        return;
      }
    }
    
    //At this point it looks like we're probably offline, but to actually assure we're online, we get some data over the network
    
    // Just because the browser says we're online doesn't mean we're online. The browser lies.
    // Check to see if we are really online by making a call for a static JSON resource on
    // the originating Web site. If we can get to it, we're online. If not, assume we're offline.
    try {
        var options = (typeof options_ != "undefined" && options_ != null) && options_ || {};
        var ajaxTimeoutMs = (typeof options.timeout != "undefined" && options.timeout != null) && options.timeout || 2800;
        var ajaxUrlPingRelative = (typeof options.pingRelative != "undefined" && options.pingRelative != null) && options.pingRelative || false;
        var ajaxUrlFilePrefix = (typeof options.pingFilePrefix != "undefined" && options.pingFilePrefix != null) && options.pingFilePrefix ||
            ('/onlineCheck.' + Math.random() * 99999999999999999);
        var ajaxUrlArgs = (typeof options.pingArgs != "undefined" && options.pingArgs != null) && options.pingArgs || "";
        // and finally...

        var ajaxUrl = ""
        if (ajaxUrlPingRelative == false) {
            // The original library behavior essentially
            ajaxUrl = location.protocol + '//' + location.hostname + ajaxUrlFilePrefix + '.json' + ajaxUrlArgs;
        } else {
            // Modification to allow the JSON file to reside relative to the location of a single page HTML5 application.
            ajaxUrl = ajaxUrlFilePrefix + '.json' + ajaxUrlArgs;
        }


      $.ajax({
        /* cache: false, //Omitted because cachebusting via querystring is unreliable.
           some proxy servers only update a cache if the filename changes, not a querystring.
           There's a apache rule to resolve the random number places in the url in the HTML5 BoilerPlate .htaccess file */
        
        timeout: ajaxTimeoutMs, //you could decrese this, and automatically assume offline if the internet is just CRAWLING - this may already be too low
        
        url: ajaxUrl
      })
      .done(function onlineCheckDone(resp) {
          var online = (typeof resp.online !== "undefined" && resp.online !== null) && resp.online || false;
          resultCallback(online);
        // Chris: I don't understand this. Corectly formed JSON will get you a response object?
        // if (resp === 'online') {
          //if (typeof resp.online !== "undefined" && resp.online !== null) 
          //resultCallback(true); //ZOMG ONLINE
        //} else {
        //  resultCallback(false);
       //}
      })
      .fail(function onlineCheckFail() {
        // We might not be technically "offline" if the error is not a timeout, but
        // otherwise we're getting some sort of error when we shouldn't, so we're
        // going to treat it as if we're offline. Perhaps the server is down.
        // Note: This might not be totally correct if the error is because the
        // manifest is ill-formed.
        
        //Search: is there a super reliable CORS responsive endpoint that the library could use?
        //Then we could verify online/offline status w/o the file, and can also discover if the server is down vs no internet
        resultCallback(false);
      });
    } catch (e) {
      console.error('did you include jQuery? (or a library implementing the same $.ajax api?)');
      throw e;
    }
  } else {
    resultCallback(false);
  }
};

var checkOffline = function checkOfflineFn(resultCallback) {
  'use strict';
  checkOnline(function(online) {
    resultCallback(!online);
  });
};
/*
```
*/
