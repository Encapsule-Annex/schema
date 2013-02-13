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
# encapsule-schema-scdl-view-model.coffee
#
# At a high level of abstraction the classes in this script comprise a hierachical object
# model that codifies the structure of Encapsule Soft Circuit Description Language (SCDL).
#
# In detail, the classes here leverage Knockout.js to make each object type in the overall
# SCDL data model "observable".
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapusle = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}
namespaceViewModel = Encapsule.app.viewmodel? and Encapsule.app.viewmodel or @Encapsule.app.viewmodel = {}
namespaceScdl = Encapsule.app.viewmodel.scdl? and Encapsule.app.viewmodel.scdl or @Encapsule.app.viewmodel.scdl = {}


class namespaceScdl.ViewModel_ScdlPerson
    constructor: (nameFirst_, nameLast_, email_, website_) ->
        Console.message("ViewModel_ScdlPerson::constructor")
        @uuid = ko.observable uuid.v4()
        @nameFirst = ko.observable nameFirst_
        @nameLast = ko.observable nameLast_
        @email = ko.observable email_
        @website = ko.observable website_

class namespaceScdl.ViewModel_ScdlOrganization
    constructor: (name_, email_, website_) ->
        Console.message("ViewModel_ScdlOrganization::constructor")
        @uuid = ko.observable uuid.v4()
        @name = ko.observable name_
        @email = ko.observable email_
        @website = ko.observable website_

class namespaceScdl.ViewModel_ScdlEntityMeta
    constructor: ->
        Console.message("ViewModel_ScdlEntityMeta::constructor")
        @uuid = ko.observable uuid.v4()
        @name = ko.observable undefined
        @description = ko.observable undefined
        @notes = ko.observable undefined
        @author = ko.observable undefined
        @organization = ko.observable undefined
        @license = ko.observable undefined
        @revision = ko.observable 0
        @createTime = ko.observable Encapsule.util.getEpochTime()
        @updateTime = ko.observable Encapsule.util.getEpochTime()

        @resetMeta = =>
            Console.message("ViewModel_ScdlEntityMeta::resetMeta")
            @uuid(uuid.v4())
            @name(undefined)
            @description(undefined)
            @notes(undefined)
            @author(undefined)
            @organization(undefined)
            @license(undefined)
            @revision(0)
            @createTime(Encapsule.util.getEpochTime())
            @updateTime(Encapsule.util.getEpochTime())



class namespaceScdl.ViewModel_ScdlAssets
    constructor: ->
        Console.message("ViewModel_ScdlAssets::constructor")
        @people = ko.observableArray []
        @organizations = ko.observableArray []
        @licenses = ko.observableArray []
        @copyrights = ko.observableArray []

        @resetAssets = =>
            Console.message("ViewModel_ScdlAssets::resetAssets")
            @people.removeAll()
            @organizations.removeAll()
            @licenses.removeAll()
            @copyrights.removeAll()



class namespaceScdl.ViewModel_ScdlType
    constructor: ->
        Console.message("ViewModel_ScdlType::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()



class namespaceScdl.ViewModel_ScdlPin
    constructor: ->
        Console.message("ViewModel_ScdlPin::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()
        @type = ko.observable undefined

        @resetPin = =>
            Console.message("ViewModel_ScdlPin::resetPin")
            @meta().resetMeta()
            @type(undefined)



class namespaceScdl.ViewModel_ScdlTransition
    constructor: ->
        Console.message("ViewModel_ScdlTransition::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()
        @targetState = ko.observable undefined
        @expression = ko.observable undefined

        @resetTransition = =>
            Console.message("ViewModel_ScdlTransition::resetTransition")
            @meta().resetMeta()
            @targetState(undefined)
            @expression(undefined)

class namespaceScdl.ViewModel_ScdlState
    constructor: ->
        Console.message("ViewModel_ScdlState::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()
        @enterAction = ko.observable undefined
        @exitAction = ko.observable undefined
        @transitions = ko.observableArray []

        @resetState = =>
            @meta().resetMeta()
            @enterAction(undefined)
            @exitAction(undefined)
            @transitions.removeAll()

class namespaceScdl.ViewModel_ScdlMachine
    constructor: ->
        Console.message("ViewModel_ScldMachine::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()
        @inputPins = ko.observableArray []
        @addInputPin = =>
            Console.message("ViewModel_ScdlMachine::addInputPin")
            @inputPins.push new namespaceScdl.ViewModel_ScdlPin()

        @outputPins = ko.observableArray []
        @addOutputPin = =>
            Console.message("ViewModel_ScdlMachine::addOutputPin")
            @outputPins.push new namespaceScdl.ViewModel_ScdlPin()

        @states = ko.observableArray []

        @addState = =>
            Console.message("ViewModel_ScdlMachine::addState")
            @states.push new namespaceScdl.ViewModel_ScdlMachineState()



class namespaceScdl.ViewModel_ScdlSystem
    constructor: ->
        Console.message("ViewModel_ScdlSystem::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()



class namespaceScdl.ViewModel_ScdlCatalogue
    constructor: ->
        Console.message("ViewModel_ScdlCatalogue::constructor")
        @meta = ko.observable new namespaceScdl.ViewModel_ScdlEntityMeta()
        @assets = ko.observable new namespaceScdl.ViewModel_ScdlAssets()
        @types = ko.observableArray []
        @machines = ko.observableArray []
        @systems = ko.observableArray []

        @addType = =>
            Console.message("ViewModel_ScdlCatalogue::addType")
            @types.push new namespaceScdl.ViewModel_ScdlType()

        @addMachine = =>
            Console.message("ViewModel_ScdlCatalogue::addMachine")
            @machines.push new namespaceScdl.ViewModel_ScdlMachine()

        @addSystem = =>
            Console.message("ViewModel_ScdlCatalogue::addSystem")
            @systems.push new namespaceScdl.ViewModel_ScdlSystem()

        @resetCatalogue = =>
            Console.message("ViewModel_ScdlCatalogue::resetCatalogue")
            @resetMeta()
            @resetAssets()
            @resetTypes()
            @resetMachines()
            @resetSystems()

        @resetMeta = =>
            Console.message("ViewMode_ScdlCatalog::resetMeta")
            @meta().resetMeta()

        @resetAssets = =>
            Console.message("ViewModel_ScdlCatalogue::resetAssets")
            @assets().resetAssets()
            

        @resetTypes = =>
            Console.message("ViewModel_ScdlCatalogue::resetTypes")
            @types.removeAll()


        @resetMachines = =>
            Console.message("ViewModel_ScdlCatalogue::resetMachines")
            @machines.removeAll()

        @resetSystems = =>
            Console.message("ViewModel_ScdlCatalogue::resetSystems")
            @systems.removeAll()



class namespaceScdl.ViewModel_ScdlCatalogueShim
    constructor: ->
        Console.message("ViewModel_ScdlCatalogueShim::constructor")
        @scdl_v1_catalogue = ko.observable new namespaceScdl.ViewModel_ScdlCatalogue()


        @resetCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueShim::resetCatalogue")
            try
                @scdl_v1_catalogue().resetCatalogue()
            catch errorException
                Console.messageError(errorException)




class namespaceScdl.ViewModel_ScdlCatalogueHost
    constructor: ->
        Console.message("ViewModel_ScdlCatalogueHost::constructor")
        @catalogueShim = ko.observable new namespaceScdl.ViewModel_ScdlCatalogueShim()

        @toJSON = ko.computed =>
            ko.toJSON @catalogueShim(), undefined, 1

        @initFromJSON = (json_) =>
            try
                @catlogueShim JSON.parse(json_)
            catch errorException
                Console.messageError(errorException)

        @initFromModelLibraryObject = (object_) =>
            @catalogueShim object_

        @resetCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueHost::resetCatalogue")
            try
                @catalogueShim().resetCatalogue()
            catch errorException
                Console.messageError(errorException)

