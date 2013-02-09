#
# schema-boot.coffee
#
namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceCore = Encapsule.core? and Encapsule.core or @Encapsule.core = {}

phase1 = (bootstrapperOptions_, onPhaseComplete_) ->
    # APP BOOT PHASE 1 : Supported browser
    #
    # Draw the boot UI
    # Initialize the debug console for this app instance
    # Confirm the visitor's browser identity and reject unsupported browsers.
    # If unsupported browser display browser help UI
    # If supported browser proceed silently and immediately to phase 2
         
    Console.init()
    Console.message("BOOTSTAP PHASE 1:")
    Console.log "#{appName} v#{appVersion} #{appReleaseName} :: #{appPackageId}"
    Console.log "#{appName}: #{appBuildTime} by #{appBuilder}"
        
    bootstrapperOptions.userAgent = userAgent = navigator.userAgent
    Console.message("Blah blah browser identity spew...")
    Console.message("#{userAgent}")
    browser = $.browser
    isChrome = browser? and browser and browser.chrome? and browser.chrome or false
    isWebKit = browser? and browser and browser.webkit? and browser.webkit or false
    browserVersion = browser? and browser and browser.version? and browser.version or "unknown"
    Console.message("isChrome=#{isChrome} isWebKit=#{isWebKit} browserVersion=#{browserVersion}")
    if isChrome
        Console.message("Your chrome shines brightly.")
    if isWebKit
        Console.message("WebKit browsers please us.")
    else
        Console.message("We note you're not running Chrome or another WebKit-based browser.")
        Console.message("This might work out for you (e.g. Firefox). Most IE users are SOL.")

    # Here's where we could bail and abort the bootstrap. For now we're just
    # pass through.

    onPhaseComplete_()

phase2 = (bootstrapperOptions_, onPhaseComplete_) ->
    Console.message("BOOTSTRAP PHASE 2")

    

class namespaceCore.bootstrapper
 
    
    @run: (bootstrapperOptions_) ->
        if not bootstrapperOptions_? or not bootstrapperOptions_
            throw "You must specify a callback function to be called on success."
        @phase1(bootstrapperOptions_, @phase2)

    @phase1: phase1
    @phase2: phase2



