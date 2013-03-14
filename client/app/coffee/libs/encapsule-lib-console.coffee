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
        $("#idConsole").html(
            """
            <div id="idClearConsole" style="float: right;">
            <button id="idButtonHideConsole" class="button orange small">Hide</button>
            <button id="idButtonClearConsole" class="button blue small">Clear</button></div>
            <img src="img/core-seablue-48x48.png" style="float:left; margin-right: 10px;">
            <h1>#{appName} v#{appVersion}</h1>
            <div style="clear: both;"></div>
            <p><strong>
                Published by <a href="#{appPackagePublisherUrl}" title="#{appPackagePublisher}" target="_blank">#{appPackagePublisher}</a> //
                #{appCopyright} //
                <strong>License:</strong> <a href="#{appLicenseUrl}" title="Read the #{appLicense} text..." target="_blank">#{appLicense}</a> //
                <strong>Sources:</strong> <a href="#{appGitHubRepoUrl}" title="#{appGitHubRepoName} repo on GitHub" target="_blank">#{appGitHubRepoName}</a>
            </strong></p>
            <p>
            Build: {#{appBuildId}}  #{appBuildTime} by <a href="mailto:#{appBuilder}">#{appBuilder}</a>
            </p>
            """
            )

        $("#idButtonClearConsole").click( ->
            Console.init()
            $("#idConsole").css( { backgroundColor: "white" } )
            Console.message("Console re-initialized.")
            )

        $("#idButtonHideConsole").click( ->
            Console.hide()
            )

    @opacity: (opacity_) =>
        consoleEl = $("#idConsole")
        consoleEl.css( { opacity: "#{opactity_}" } )

    
    @show: () =>
        consoleEl = $("#idConsole")
        if consoleEl? and consoleEl
            consoleEl.show()

    @hide: () =>
        consoleEl = $("#idConsole")
        if consoleEl? and consoleEl
            consoleEl.hide()

    @log: (trace) =>
        if console? and console and console.log? and console.log
           console.log trace


    @message: (trace) =>
        @messageStart(trace)
        @messageEnd("")

    @messageRaw: (trace) => 
        consoleEl = $("#idConsole")
        consoleEl.append("#{trace}")


    @messageStart: (trace) => Console.messageRaw("> #{trace}")

    @messageEnd: (trace) => Console.messageRaw("#{trace}<br>")


    @messageError: (errorException) =>
        errorMessage =
            """
            <h2>#{appName} v#{appVersion} Exception</h2>
            <h3>An unexpected error has occurred in #{appName} v#{appVersion} #{appReleaseName}.</h3>
            <p>Exception detail:</p>
            <div style="margin: 5px; margin-top-15px; padding: 10px; background-color: #FF9900;
                border: 1px solid yellow;">#{errorException}</div>
            """

        Console.messageRaw(errorMessage)
        @log("Encapsule:: #{errorException}")
        consoleEl = $("#idConsole")
        consoleEl.show()
        consoleEl.css( { opacity: "1.0", backgroundColor: "#FFCC00" } )
        Encapsule.runtime.boot.phase0.spinner.cancel()
        alert(errorException)

