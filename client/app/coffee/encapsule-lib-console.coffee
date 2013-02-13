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
            <button id="idButtonClearConsole" class="button blue medium">Clear</button></div>
            <img src="img/core-seablue-72x72.png" style="float:left;">
            <h1>#{appName} v#{appVersion} ("#{appReleaseName}" release)</h1>
            <p>#{appCopyright} // Published under the
            <a href="#{appLicenseUrl}" title="Read the #{appLicense} text..." target="_blank">#{appLicense}</a>
            // [ <a href="#{appGitHubRepoUrl}" title="#{appGitHubRepoName} repo on GitHub" 
            target="_blank">GitHub repo #{appGitHubRepoName}</a> ]
            [ <a href="#{appBlogUrl}" title="Visit #{appBlogName}" target="_blank">#{appBlogName}</a> ] 
            </p>
            <p>
            Released #{appBuildTime} by <a href="mailto:#{appBuilder}">#{appBuilder}</a>
            [ Build ID: #{appBuildId} ]
            </p>
            """
            )

        $("#idButtonClearConsole").click( ->
            Console.init()
            Console.message("Console re-initialized.")
            )

    @log: (trace) =>
        if console? and console and console.log? and console.log
           console.log trace


    @message: (trace) =>
        @messageStart(trace)
        @messageEnd("")

    @messageRaw: (trace) => 
        $("#idConsole").append("#{trace}")

    @messageStart: (trace) => Console.messageRaw("> #{trace}")

    @messageEnd: (trace) => Console.messageRaw("#{trace}<br>")


    @messageError: (errorException) =>
        errorMessage =
            """
            <h2>attention please</h2>
            <h3>An unexpected error has occurred in #{appName} v#{appVersion} #{appReleaseName}.</h3>
            <p>Exception detail:</p>
            <div style="margin: 5px; margin-top-15px; padding: 10px; background-color: #FFEEDD;
                border: 5px solid red;">#{errorException}</div>
            """

        Console.messageRaw(errorMessage)
        @log("Encapsule:: #{errorException}")
        $("#idConsole").show()
        alert(errorException)


