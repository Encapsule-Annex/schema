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
# schema.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


namespaceEncapsule_runtime.boot = {
    onBootstrapComplete: (bootstrapperStatus_) ->
        Console.messageRaw("<h3>BOOTSTRAP COMPLETE</h3>")
        Console.message("status=\"<strong>#{bootstrapperStatus_}</strong>\"")
        namespaceEncapsule_app.schema = new Encapsule.code.app.Schema()
    }

$ ->
    try
        Encapsule.code.app.bootstrapper.run Encapsule.runtime.boot
    catch exception
        Console.messageError(exception)
    @




