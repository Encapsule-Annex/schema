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
            <h1>console: #{appName} v#{appVersion} (#{appReleaseName})</h1><br>"
            )

        $("#idButtonClearConsole").click( ->
            Console.init()
            Console.message("Console re-initialized.")
            )


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
        console.log("Encapsule:: #{errorException}")
        alert(errorException)


