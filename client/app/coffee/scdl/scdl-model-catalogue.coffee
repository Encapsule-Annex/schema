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
        @systems = ko.observableArray []
        @sockets = ko.observableArray []
        @socketContracts = ko.observableArray []

        @addType = =>
            @types.push new Encapsule.code.app.scdl.model.ObservableType()

        @addMachine = =>
            @machines.push new Encapsule.code.app.scdl.model.ObservableMachine()

        @addSystem = =>
            @systems.push new Encapsule.code.app.scdl.model.ObservableSystem()

        @addSocket = =>
            @sockets.push new Encapsule.code.app.scdl.model.ObservableSocket()

        @addSocketContract = =>
            @socketContracts.push new Encapsule.code.app.scdl.model.ObservableSocketContract()

        @reinitializeCatalogue = =>
            @meta().reinitializeMeta()
            @removeAllModels()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllModels = =>
            @removeAllTypes()
            @removeAllMachines()
            @removeAllSystems()
            @removeAllSockets()
            @removeAllSocketContracts()

        @removeAllTypes = =>
            @types.removeAll()

        @removeAllMachines = =>
            @machines.removeAll()

        @removeAllSystems = =>
            @systems.removeAll()
 
        @removeAllSockets = =>
            @sockets.removeAll()

        @removeAllSocketContracts = =>
            @socketContracts.removeAll()




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelCatalogue", ( ->
    """
    <div class="classScdlModelCatalogue">
        <h2>SCDL Models:</h2>
        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelTypes' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachines' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSockets' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSocketContracts' }"></div>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSystems' }"></div>
    </div>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelTypes", ( ->
    """
    <div class="classScdlModelTypes">
        <h3>SCDL Type Models:</h3>
        <p>A SCDL type model is a label applied to input and output pins to denote the type of information that passed between pins via SCDL node models.</p>
        <button data-bind="click: addType" class="button small green">Add Type</button>
        <button data-bind="click: removeAllTypes" class="button small red">Remove All Types</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelType', foreach: types }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelMachines", ( ->
    """
    <div class="classScdlModelMachines">
        <h3>SCDL Machine Models:</h3>
        <p>SCDL machine models represent computation engines based on a Turing Machine model. You can think of SCDL machine as small re-usable algorithm that acts metaphorically like a special-purpose integrated circuit.</p>
        <button data-bind="click: addMachine" class="button small green">Add Machine</button>
        <button data-bind="click: removeAllMachines"  class="button small red">Remove All Machines</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelMachine', foreach: machines }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelSockets", ( ->
    """
    <div class="classScdlModelSockets">
        <h3>SCDL Socket Models:</h3>
        <p>SCDL socket models define a set of input and output pins that may be included within a SCDL module model to define a system extension point.</p>
        <button data-bind="click: addSocket" class="button small green">Add Socket</button>
        <button data-bind="click: removeAllSockets"  class="button small red">Remove All Sockets</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSocket', foreach: sockets }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelSocketContracts", ( ->
    """
    <div class="classScdlModelSocketContracts">
        <h3>SCDL Socket Contract Models:</h3>
        <p>SCDL socket contract models define a mapping contract between a specific SCDL socket model and a specific SCDL machine or module model. The existence of a SCDL socket contract between a socket and machine or module model indicates that system can be extended by inserting the machine or module model into the socket. The contract determines how the pins are connected upon insertion.</p>
        <button data-bind="click: addSocketContract" class="button small green">Add Socket Contract</button>
        <button data-bind="click: removeAllSocketContracts"  class="button small red">Remove All Socket Contracts</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSocketContract', foreach: socketContracts }"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlModelSystems", ( ->
    """
    <div class="classScdlModelSystems">
        <h3>SCDL System Models:</h3>
        <p>A SCDL system defines a re-usable topology of SCDL machines, other systems, and sockets that functions as the atomic building block of SCDL systems. You should think of a SCDL system as a special purpose circuit board that embodies some useful functionality. Importantly, because SCDL systems may contain SCDL sockets, a set of SCDL systems along with a set of SCDL socket contracts, constitutes a "kit" from which entire classes of systems may be constructed (i.e. any system for which an edge exists in the SCDL socket closure graph may be composed). This is an insanely powerful concept that we hope to leverage to promote broad re-use of IP encapsulated in SCDL.</p>
        <button data-bind="click: addSystem" class="button small green">Add System</button>
        <button data-bind="click: removeAllSystems"  class="button small red">Remove All Systems</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlModelSystem', foreach: systems }"></div>
    </div>
    """))


