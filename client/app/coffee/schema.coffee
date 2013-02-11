#
# schema.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}

@Encapsule.app.boot = {
    onBootstrapComplete: (bootstrapperStatus_) ->
        Console.message("onBootstrapperComplete with status=#{bootstrapperStatus_}")
    }

$ ->
    try
        Encapsule.core.bootstrapper.run Encapsule.app.boot
    catch exception
        Console.messageError(exception)
    @




