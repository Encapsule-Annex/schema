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
# schema-view-model.coffee
#
# class Encapsule.code.app.SchemaViewModel is a singleton object instantiated by
# class Encapsule.code.app.SchemaApp's constructor. SchemaViewModel encapsulates
# the overall model view of the Schema application and is itself a nested hiearchy
# of ko.observable/observableArrays. Specific branches/leafs of this hierachy
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.app.SchemaViewModel
    constructor: ->
        # BEGIN: \ constructor scope
        try
            # BEGIN: \ constructor try scope
            Console.message("Initializing #{appName} model view.")

            # The currently selected SCDL catalogue.
            @currentScdlCatalogue = ko.observable new Encapsule.code.app.ObservableCatalogueShimHost


            # END: / constructor try scope
        catch exception
            throw "SchemaViewModel constructor fail: #{exception}"
        # END: / constructor scope


