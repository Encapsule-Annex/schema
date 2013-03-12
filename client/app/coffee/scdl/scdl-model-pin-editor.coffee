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
# schema/client/app/coffee/scdl/scdl-model-pin-editor.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_editor = Encapsule.code.app.scdl.editor? and Encapsule.code.app.scdl.editor or @Encapsule.code.app.scdl.editor = {}

class Encapsule.code.app.scdl.editor.ObservablePinEditor
    constructor: (direction_, fnNewPinCallback_) ->

        # newPin is inititialized with an ObvervablePin instance. 
        @newPin = ko.observable new Encapsule.code.app.scdl.model.ObservablePin(direction_)

        @fnNewPinCallback  = fnNewPinCallback_

        @submitNewPin = (this_) =>
            @fnNewPinCallback(@newPin)
            
        # SCDL editor state
        @availableTypes = ko.computed( ->
            test = Encapsule.runtime.app.viewmodel.scdl.catalogueShim().scdlCatalogue().modelCatalogue().types
            )


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelPinEditor", ( ->
    """
    <h2>Hello this is the Pin Editor</h2>
    <span data-bind="with: scdlModelPinEditor">
        <button data-bind="click: submitNewPin" class="button small green">Submit New Pin</button>
    </span>
    """))
