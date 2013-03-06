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
# schema/client/app/coffee/scdl/scdl-model-machine-state.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}
namespaceEncapsule_code_app_scdl_model = Encapsule.code.app.scdl.model? and Encapsule.code.app.scdl.model or @Encapsule.code.app.scdl.model = {}


class namespaceEncapsule_code_app_scdl_model.ObservableMachineState
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @enterAction = ko.observable undefined
        @exitAction = ko.observable undefined

        @reinitializeState = =>
            @meta().reinitializeMeta()
            @enterAction(undefined)
            @exitAction(undefined)



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlMachineStateEnter", ( ->
    """
    State Enter Action: <span data-bind="text: enterAction"></span>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlMachineStateExit", ( ->
    """
    State Exit Action: <span data-bind="text: exitAction"></span>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlMachineState", ( ->
    """
    <div class="classScdlMachineState">
        <h4>State <span data-bind="text: $index"></span>:</h4>
        <button data-bind="click: reinitializeState" class="button small red">Re-initialize State</button>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStateEnter_View' }" class="classScdlMachineStateEnter"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStateExit_View' }" class="classScdlMachineStateExit"></div>
    </div>
    """))

