###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-console.coffee
#

class window.Console
    constructor: ->

    @init: =>

        consoleEl = $("#idConsole")
        if not consoleEl? or not consoleEl
            throw "Unable to resolve the #idConsole DIV."

        if Encapsule.runtime.app.SchemaWindowManager? and Encapsule.runtime.app.SchemaWindowManager
            consoleEl.html("reset")
            Encapsule.runtime.app.SchemaWindowManager.refreshWindowManagerViewState { forceEval: true }

        consoleEl.html(
            """
            <div id="idClearConsole" style="float: right;">
                <button id="idButtonClearConsole" class="button red small">Reset Console</button>
                <button id="idButtonHideConsole" class="button blue small">Hide Console</button>
            </div>
            <img src="img/core-seablue-48x48.png" style="float:left; margin-right: 10px;">
            <h1>#{appName} v#{appVersion}</h1>
            <div style="clear: both;"></div>
            <p>
                <strong>Copyright:</strong> #{appCopyright} &bull;
                <strong>License:</strong> <a href="#{appLicenseUrl}" title="Read the #{appLicense} text..." target="_blank">#{appLicense}</a> &bull;
                <strong>Sources:</strong> <a href="#{appGitHubRepoUrl}" title="#{appGitHubRepoName} repo on GitHub" target="_blank">#{appGitHubRepoName}</a>
            </p>
            <p>
            Build: {#{appBuildId}}  #{appBuildTime} by <a href="mailto:#{appBuilder}">#{appBuilder}</a>
            </p>
            """
            )


        $("#idButtonClearConsole").click( ->
            consoleEl = $("#idConsole").css( { backgroundColor: "#CCCCCC" } )
            Console.init()
            Console.message("Console re-initialized.")
            )

        $("#idButtonHideConsole").click( ->
            Console.hide()
            )


    @opacity: (opacity_) =>
        consoleEl = $("#idConsole")
        consoleEl.css( { opacity: "#{opacity_}" } )

    
    @show: () =>
        consoleEl = $("#idConsole")
        if consoleEl? and consoleEl
            consoleEl.hide 0, ->
                Console.opacity(1.0)
                consoleEl.show 500

    @hide: () =>
        consoleEl = $("#idConsole")
        if consoleEl? and consoleEl
            consoleEl.hide 500, ->
                Console.opacity(0.0)
                if Encapsule.runtime.app.SchemaWindowManager? and Encapsule.runtime.app.SchemaWindowManager
                    Encapsule.runtime.app.SchemaWindowManager.refreshWindowManagerViewState { forceEval: true }

    @log: (trace) =>
        @message(trace)
        if console? and console and console.log? and console.log
           console.log trace


    @message: (trace) =>
        @messageStart(trace)
        @messageEnd("")

    @messageRaw: (trace) => 
        consoleEl = $("#idConsole")
        consoleEl.append(trace)

    @messageStart: (trace) => Console.messageRaw("> #{trace}")

    @messageEnd: (trace) => Console.messageRaw("#{trace}<br>")


    @messageError: (errorException) =>
        errorMessage =
            """
            <h2 style="color: #990000;">#{appName} Runtime Exception</h2>
            <div class="classConsoleExceptionContainer">
                <h3 style="color: #660000">#{appName} v#{appVersion} RUNTIME EXCEPTION:</h3>
                <h4>AppID: #{appId} &bull; ReleaseID: #{appReleaseId} &bull; AppBuildID: #{appBuildId}</h4>
                <div style="margin: 5px; margin-top-15px; padding: 10px; background-color: #FF9900; border: 1px solid black;">#{errorException}</div>
            </div>
            """

        Console.messageRaw(errorMessage)
        @log("!!!! #{errorException}")
        consoleEl = $("#idConsole")
        consoleEl.show()
        consoleEl.css( { opacity: "1.0", backgroundColor: "#FFCC00" } )
        Encapsule.runtime.boot.phase0.spinner.cancel()

        if Encapsule? and Encapsule.runtime? and Encapsule.runtime.boot? and Encapsule.runtime.boot.phase0? and Encapsule.runtime.boot.phase0.blipper?
            blipper = Encapsule.runtime.boot.phase0.blipper
            blipper.blip "22a"
            blipper.blip "warning"



