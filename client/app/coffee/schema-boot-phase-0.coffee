#
# schema-boot-phase-0.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceCore = Encapsule.core? and Encapsule.core or @Encapsule.core = {}
namespaceBoot = Encapsule.core.boot? and Encapsule.core.boot or @Encapsule.core.boot= {}

class namespaceBoot.Phase0
    @execute: (successCallback_) ->
        if not successCallback_? and not successCallback_
            throw "You must specify a callback function to be called on success."

        # APP BOOT PHASE 1 : Supported browser
        #
        # Draw the boot UI
        # Initialize the debug console for this app instance
        # Confirm the visitor's browser identity and reject unsupported browsers.
        # If unsupported browser display browser help UI
        # If supported browser proceed silently and immediately to phase 2
     
        Console.init()
        Console.message("Hello from the schema bootrapper!")
        Console.log "#{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
        Console.log "#{appName}: #{appBuildTime} by #{appBuilder}"
    
        userAgent = navigator.userAgent
        Console.message("Your browser purports to be a \"#{userAgent}\"")
        browser = $.browser

        successCallback_()
            

            
    

