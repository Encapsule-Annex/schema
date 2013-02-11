# arachne-console.coffee

class window.Console
    constructor: ->

    @init: => 
        $("#idConsole").html(
            "<div id=\"idClearConsole\"
            class=\"classInvisibleDivContainer\"
            style=\"float: right;\">
            <button id=\"idButtonClearConsole\"
            class=\"button blue medium\">
            Clear</button></div>
            <h1>#{appName} v#{appVersion} (\"#{appReleaseName}\" release)</h1>
            <p>
            #{appCopyright} //
            Published under the <a href=\"#{appLicenseUrl}\" title=\"Read the #{appLicense} text...\" target=\"_blank\">#{appLicense}</a> //
            [ <a href=\"https://github.com/Encapsule/schema\" title=\"Encapsule Project on GitHub\" target=\"_blank\">GitHub</a> ]
            [ <a href=\"http://blog.encapsule.org\" title=\"Encapsule Project Blog\" target=\"_blank\">Blog</a> ] 
            <p>
            <p>
            Released #{appBuildTime} by <a href=\"mailto:#{appBuilder}\">#{appBuilder}</a>
            [ Build ID: #{appBuildId} ]
            </p>"
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
            "<div style=\"margin: 5px; margin-top-15px; padding: 10px;
             background-color: #FFEEDD; border: 5px solid red;\">
             <strong>The application crashed due to an unhandled exception:</strong><br><br>
             <span style=\"font-weight: bold; color:red\">#{errorException}</span><br>
            </div>"
        Console.messageRaw(errorMessage)
        @log("Encapsule:: #{errorException}")
        alert(errorException)


