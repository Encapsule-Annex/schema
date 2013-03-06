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
# schema/client/app/coffee/scdl/scdl-model-catalogue.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableModelCatalogue
    constructor: ->

        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @types = ko.observableArray []
        @machines = ko.observableArray []
        @sockets = ko.observableArray []
        @socketContracts = ko.observableArray []

        @addType = =>
            @types.push new Encapsule.code.app.scdl.model.ObservableType()

        @addMachine = =>
            @machines.push new Encapsule.code.app.scdl.model.ObservableMachine()

        @addSocket = =>
            @sockets.push new Encapsule.code.app.scdl.model.ObservableSocket()

        @addSocketContract = =>
            @socketContracts.push new Encapsule.code.app.scdl.model.ObservableSocketContract()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllModels = =>
            @reinitializeMeta()
            @removeAllTypes()
            @removeAllMachines()
            @removeAllSockets()
            @removeAllSocketContracts()

        @removeAllTypes = =>
            @types.removeAll()

        @removeAllMachines = =>
            @machines.removeAll()

        @removeAllSockets = =>
            @sockets.removeAll()

        @removeAllSocketContracts = =>
            @socketsContracts.removeAll()




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelCatalogue", ( ->
    """
    <div class="classScdlModelCatalogue">
        <h2>This is a SCDL model catalogue</h2>
        <div class="classScdlCatalogueButtons">
            <button data-bind="click: addMachine" class="button small green">Add Machine</button>
            <button data-bind="click: removeAllMachines"  class="button small red">Remove All Machines</button>
            <button data-bind="click: addModule" class="button small green">Add Module</button>
            <button data-bind="click: removeAllModules"  class="button small red">Remove All Modules</button>
            <button data-bind="click: addSocket" class="button small green">Add Machine</button>
            <button data-bind="click: removeAllSockets"  class="button small red">Remove All Machines</button>
            <button data-bind="click: addSocketContract" class="button small green">Add Socket Contract</button>
            <button data-bind="click: removeAllSockets"  class="button small red">Remove All Socket Contracts</button>
            <button data-bind="click: addType" class="button small green">Add Type</button>
            <button data-bind="click: removeAllTypes" class="button small red">Remove All Types</button>
        </div>
    </div>
    """))

