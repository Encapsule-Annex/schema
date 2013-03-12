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
# schema/client/app/coffee/scdl/scdl-editor.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_editor = Encapsule.code.app.scdl.editor? and Encapsule.code.app.scdl.editor or @Encapsule.code.app.scdl.editor = {}


class Encapsule.code.app.scdl.editor.ObservableEditor
    constructor: ->

        @scdlModelPinEditor = ko.observable undefined
        @fnNewPinCallback = undefined


        @createPin = (direction_, fnNewPinCallback_) =>
            @fnNewPinCallback = fnNewPinCallback_
            @scdlModelPinEditor new Encapsule.code.app.scdl.editor.ObservablePinEditor(direction_, @submitNewPin)

        @submitNewPin = (newPin_) =>
            @fnNewPinCallback newPin_
            @fnNewPinCallback = undefined
            @scdlModelPinEditor(undefined)
         
            


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlEditor", ( ->
    """
    <h1>Hello this is the SCDL Catalogue Editor View</h1>

    <span data-bind="if: scdlModelPinEditor">
        <span data-bind="template: { name: 'idKoTemplate_ScdlModelPinEditor' }"></span>
    </span>

    """))
