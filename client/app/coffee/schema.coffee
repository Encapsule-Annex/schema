#
# schema.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}

@Encapsule.app.boot = {
    onBootstrapComplete: (bootstrapperStatus_) ->
        Console.messageRaw("<h3>BOOTSTRAP COMPLETE</h3>")
        Console.message("onBootstrapperComplete has been called with status=\"<strong>#{bootstrapperStatus_}</strong>\"")
        Console.message("Booting #{appName}...")
        appSchema = new Encapsule.app.Schema()
    }

$ ->
    try
        Encapsule.core.bootstrapper.run Encapsule.app.boot
    catch exception
        Console.messageError(exception)
    @




