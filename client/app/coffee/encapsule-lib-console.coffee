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

            <div style=\"\">
                <div style=\"float: left;\"><img src=\"img/encapsule-logo-48x48.png\" width=\"48\" height=\"48\"></div>
                <div style=\"float: left;\">
                    <span style=\"font-size: 20pt; font-weight: normal;\">#{appName} #{appReleaseName} v#{appVersion}</span><br>
                    <span style=\"font-size: 9pt; padding-top: 10px;\">Build: #{appBuildTime} // Builder: #{appBuilder} // 
                    [ <a href=\"https://github.com/Encapsule/schema\">GitHub</a> ]
                    [ <a href=\"http://blog.encapsule.org\">Blog</a> ]</span>
                </div>
                <div style=\"border-bottom: 1px solid black; clear: both;\"></div>
            </div><br>"
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


