#
# schema-app.coffee
#
# Post-bootstrap entry point to Encapsule Schema HTML application.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}


class namespaceApp.SchemaViewModel
    constructor: ->
        self = @
        self.samPath = ko.observable "test"

        sammyRouter = $.sammy( ->
            @get '', (context_) ->
                self.samPath(context_.path)
                @
            @get '#', (context_) ->
                self.samPath(context_.path)
                @
            @get '#/', (context_) ->
                self.samPath(context_.path)
                @
            @get '#/hell', (context_) ->
                self.samPath(context_.path)
                @
            )
        sammyRouter.run()        


class namespaceApp.Schema
    constructor: ->

        bodyElement = $("body")

        appViewHtml = $ "<div id=\"idSchemaAppView\" data-bind=\"text: samPath\"></div>"

        bodyElement.append appViewHtml

        appViewModel = new Encapsule.app.SchemaViewModel()
        ko.applyBindings(appViewModel)


