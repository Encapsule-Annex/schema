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


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_viewmodel = Encapsule.code.app.viewmodel? and Encapsule.code.app.viewmodel or @Encapsule.code.app.viewmodel = {}


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPerson
    constructor: (nameFirst_, nameLast_, email_, website_, gitUsername_) ->
        Console.message("ViewModel_ScdlPerson::constructor")
        @uuid = ko.observable uuid.v4()
        @nameFirst = ko.observable nameFirst_
        @nameLast = ko.observable nameLast_
        @email = ko.observable email_
        @website = ko.observable website_
        @gitUsername = ko.observable gitUsername_

        @reinitializePerson = =>
            @uuid(uuid.v4())
            @nameFirst(undefined)
            @nameLast(undefined)
            @email(undefined)
            @website(undefined)
            @gitUsername(undefined)

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlOrganization
    constructor: (name_, email_, website_) ->
        Console.message("ViewModel_ScdlOrganization::constructor")
        @uuid = ko.observable uuid.v4()
        @name = ko.observable name_
        @email = ko.observable email_
        @website = ko.observable website_

        @reinitializeOrganization = =>
            @uuid(uuid.v4())
            @name(undefined)
            @email(undefined)
            @website(undefined)

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlLicense
    constructor: (name_, terms_, website_) ->
        @uuid = ko.observable uuid.v4()
        @name = ko.observable name_
        @terms = ko.observable terms_
        @website = ko.observable website_

        @reinitializeLicense = =>
            @uuid(uuid.v4())
            @name(undefined)
            @terms(undefined)
            @website(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCopyright
    constructor: (notice_) ->
        @uuid = ko.observable uuid.v4()
        @notice = ko.observable notice_

        @reinitializeCopyright = =>
            @uuid(uuid.v4())
            @notice(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta
    constructor: ->
        Console.message("ViewModel_ScdlEntityMeta::constructor")
        @uuid = ko.observable uuid.v4()
        @name = ko.observable undefined
        @description = ko.observable undefined
        @notes = ko.observable undefined
        @author = ko.observable undefined
        @organization = ko.observable undefined
        @license = ko.observable undefined
        @copyright = ko.observable undefined
        @revision = ko.observable 0
        @createTime = ko.observable Encapsule.code.lib.util.getEpochTime()
        @updateTime = ko.observable Encapsule.code.lib.util.getEpochTime()

        @reinitializeMeta = =>
            @uuid(uuid.v4())
            @name(undefined)
            @description(undefined)
            @notes(undefined)
            @author(undefined)
            @organization(undefined)
            @license(undefined)
            @revision(0)
            @createTime(Encapsule.code.lib.util.getEpochTime())
            @updateTime(Encapsule.code.lib.util.getEpochTime())



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlAssets
    constructor: ->
        Console.message("ViewModel_ScdlAssets::constructor")
        @people = ko.observableArray []
        @organizations = ko.observableArray []
        @licenses = ko.observableArray []
        @copyrights = ko.observableArray []

        @removeAllAssets = =>
            @people.removeAll()
            @organizations.removeAll()
            @licenses.removeAll()
            @copyrights.removeAll()

        @removeAllPeople = =>
            @people.removeAll()

        @removeAllOrganizations = =>
            @organizations.removeAll()

        @removeAllLicenses = =>
            @licenses.removeAll()

        @removeAllCopyrights = =>
            @copyrights.removeAll()

        @addPerson = =>
            @people.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPerson()

        @addOrganization = =>
            @organizations.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlOrganization()

        @addLicense = =>
            @licenses.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlLicense()

        @addCopyright = =>
            @copyrights.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCopyright()


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlType
    constructor: ->
        Console.message("ViewModel_ScdlType::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @descriptor = ko.observable undefined

        @resetType = =>
             @meta().reinitializeMeta()
             @descriptor(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin
    constructor: (direction_) ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @typeRef = ko.observable undefined
        @direction = ko.observable direction_

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @reinitializePin = =>
            Console.message("ViewModel_ScdlPin::resetPin")
            @meta().reinitializeMeta()
            @typeRef(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransitionVector
    constructor: ->
        Console.message("ViewModel_ScdlTransition::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @nextState = ko.observable undefined
        @expression = ko.observable undefined

        @resetTransitionVector = =>
            Console.message("ViewModel_ScdlTransition::resetTransition")
            @meta().reinitializeMeta()
            @targetState(undefined)
            @expression(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransition
    constructor: ->
        @startState = ko.observable undefined
        @vectors = ko.observableArray []

        @reinitializeTransition = =>
            @startState(undefined)
            @vectors.removeAll()

        @removeAllVectors = =>
            @vectors.removeAll()

        @addVector = =>
            @vectors.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransitionVector()


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachineState
    constructor: ->
        Console.message("ViewModel_ScdlState::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @enterAction = ko.observable undefined
        @exitAction = ko.observable undefined

        @reinitializeState = =>
            @meta().reinitializeMeta()
            @enterAction(undefined)
            @exitAction(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachine
    constructor: ->
        Console.message("ViewModel_ScldMachine::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @inputPins = ko.observableArray []
        @outputPins = ko.observableArray []
        @states = ko.observableArray []
        @transitions = ko.observableArray []

        @reinitializeMachine = =>
            @reinitializeMeta()
            @removeAllInputPins()
            @removeAllOutputPins()
            @removeAllTransitions()
            @removeAllStates()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllInputPins = =>
            @inputPins.removeAll()

        @removeAllOutputPins = =>
            @outputPins.removeAll()

        @removeAllPins = =>
            @removeAllInputPins()
            @removeAllOutputPins()

        @removeAllTransitions = =>
            @transitions.removeAll()

        @removeAllStates = =>
            @states.removeAll()

        @addInputPin = =>
            Console.message("ViewModel_ScdlMachine::addInputPin")
            @inputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin("Input")

        @addOutputPin = =>
            Console.message("ViewModel_ScdlMachine::addOutputPin")
            @outputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin("Output")

        @addState = =>
            Console.message("ViewModel_ScdlMachine::addState")
            @states.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachineState()

        @addTransition = =>
            @transitions.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransition()








class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPinInstance
    constructor: ->
        modelInstanceId = ko.observable undefined
        pinId = ko.obvervable undefined


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlNode
    # A SCDL node model defines a binding between a specific output pin and some number of input
    # pins. Arrays of SCDL node models are used to define data flow graph I/O topologies between
    # components.
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @sourcePinInstance = ko.observable new namespaceEncapsule_code_app_viewmode.ViewModel_ScdlPinInstance()
        @sinkPinInstances = ko.observableArray []


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlModelInstance
    # A SCDL model instance references a system, machine, or socket model indirectly via it's UUID.
    constructor: ->
        # UUID of the meta object is used to identify the specific instance of the contained model entity.
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @modelRef = ko.observable undefined
        @modelEntityRef = ko.observable undefined


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlModule
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @externalInputPins = ko.observableArray []
        @externalOutputPins = ko.observableArray []
        @internalModelInstances = ko.observableArray []
        @internalNodes = ko.observableArray []


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSocket
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @inputPins = ko.observableArray []
        @outputPins = ko.observableArray []
        @populationRequired = ko.observable false
        @populationLimit = ko.observable 1
        @partitionPopulation = ko.observable false
        @partitionType = ko.observable undefined


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSocketContract
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @socketUuid = ko.observable undefined
        @modelUuid = ko.observable undefined
        @nodes = ko.observableArray [] # array of ScdlNode objects
        

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSocketBoundModule
    constructor: ->
        @socketContractId = ko.observable undefined # the identity of the socket binding contract
        @socketedModuleInstance = ko.observable undefined


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSystemModuleSocketBinder
    constructor: ->
        # moduleSocketInstanceId is the instance ID of a specific SCDL socket contained within
        # a SCDL module model.
        @moduleSocketInstanceId = ko.observable undefined

        @socketedSystemModuleInstances = ko.observableArray []




class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSystemModule
    constructor: ->

        # The contained moduleInstance is a ScdlModelInstance refering to a unique instance
        # of a SCDL module model.

        @moduleInstance = ko.observable undefined

        # A SCDL module model may optionally define one or more extensibility points via contained
        # SCDL socket model(s). Our frame of reference in this object scope here is a single module.
        #
        # moduleSocketBindings is an array of ScdlSystemModuleSocketBinder objects each of which
        # map a socket instance defined by this ScdlSystemModule's associated ScdlModule model to
        # an array of ScdlSystemModule objects that are "socketed" (i.e. connected via the terms
        # of a ScdlSocketContract object.


        @moduleSocketBindings = ko.observableArray [] # an array of ScdlSystemModuleSocketBinder objects





 

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSystem
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()

        # An array of SCDL module module instances




class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogue
    constructor: ->
        Console.message("ViewModel_ScdlCatalogue::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @assets = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlAssets()
        @types = ko.observableArray []
        @machines = ko.observableArray []
        @systems = ko.observableArray []

        @addType = =>
            Console.message("ViewModel_ScdlCatalogue::addType")
            @types.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlType()

        @addMachine = =>
            Console.message("ViewModel_ScdlCatalogue::addMachine")
            @machines.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachine()

        @addSystem = =>
            Console.message("ViewModel_ScdlCatalogue::addSystem")
            @systems.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSystem()

        @reinitializeCatalogue = =>
            Console.message("ViewModel_ScdlCatalogue::resetCatalogue")
            @reinitializeMeta()
            @removeAllAssets()
            @removeAllTypes()
            @removeAllMachines()
            @removeAllSystems()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllAssets = =>
            @assets().removeAllAssets()
            
        @removeAllTypes = =>
            @types.removeAll()

        @removeAllMachines = =>
            @machines.removeAll()

        @removeAllSystems = =>
            @systems.removeAll()



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogueShim
    constructor: ->
        Console.message("ViewModel_ScdlCatalogueShim::constructor")
        @scdl_v1_catalogue = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogue()


        @reinitializeCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueShim::resetCatalogue")
            try
                @scdl_v1_catalogue().reinitializeCatalogue()
            catch errorException
                Console.messageError(errorException)




class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogueHost
    constructor: ->
        Console.message("ViewModel_ScdlCatalogueHost::constructor")
        @catalogueShim = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogueShim()

        @toJSON = ko.computed =>
            ko.toJSON @catalogueShim(), undefined, 1

        @initFromJSON = (json_) =>
            try
                @catlogueShim JSON.parse(json_)
            catch errorException
                Console.messageError(errorException)

        @initFromModelLibraryObject = (object_) =>
            @catalogueShim object_

        @reinitializeCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueHost::resetCatalogue")
            try
                @catalogueShim().reinitializeCatalogue()
            catch errorException
                Console.messageError(errorException)


        @saveJSONAsLinkHtml = ko.computed =>

            # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
            html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"

class namespaceEncapsule_code_app_viewmodel.scdl
    constructor: ->
        try
            self = @
            self.appPath = ko.observable ""
            self.scdlHost = ko.observable new Encapsule.code.app.viewmodel.ViewModel_ScdlCatalogueHost()


            @html = $("""

            <!-- SCDL HTML VIEW TEMPLATES -->

            <div id="idKoTemplates" style="display: none;">

            <script type="text/html" id="idKoTemplate_ScdlPerson_View">
                <div class="classScdlAssetsPerson">
                    <h3>
                        Person:
                        <button data-bind="click: reinitializePerson" class="button small red">Re-initialize Person</button>
                    </h3>
                    UUID: <span data-bind="text: uuid"></span><br>
                    First Name: <span data-bind="text: nameFirst"></span><br>
                    Last Name: <span data-bind="text: nameLast"></span><br>
                    E-mail: <span data-bind="text: email"></span><br>
                    Website: <span data-bind="text: website"></span><br>
                    GitUsername: <span data-bind="text: gitUsername"></span><br>            
                </div>
            </script><!-- idKoTemplate_ScdlPerson_View -->


            <script type="text/html" id="idKoTemplate_ScdlPeople_View" class="classEditAreaAssetsPeople">
                <div class="classEditAreaAssetsPeople">
                    <h2>
                        People:
                        <button data-bind="click: addPerson" class="button small green">Add Person</button>
                        <button data-bind="click: removeAllPeople" class="button small red">Remove All People</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlPerson_View', foreach: people }" class="classScdlAssetsPeople"></div>
                </div>
            </script><!-- idKoTemplate_ScdlPeople_View -->


            <script type="text/html" id="idKoTemplate_ScdlOrganization_View">
                <div class="classScdlAssetsOrganization">
                    <h3>Organization:
                        <button data-bind="click: reinitializeOrganization" class="button small red">Re-initialize Organization</button>
                    </h3>
                    UUID: <span data-bind="text: uuid"></span><br>
                    Name: <span data-bind="text: name"></span><br>
                    E-mail: <span data-bind="text: email"></span><br>
                    Website: <span data-bind="text: website"></span><br>
                </div>
            </script><!-- idKoTempalte_ScdlOrganization_View -->

            <script type="text/html" id="idKoTemplate_ScdlOrganizations_View">
                <div class="classEditAreaAssetsOrganizations">
                    <h2>
                        Organizations:
                        <button data-bind="click: addOrganization" class="button small green">Add Organization</button>
                        <button data-bind="click: removeAllOrganizations" class="button small red">Remove All Organizations</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlOrganization_View', foreach: organizations }" class="classScdlAssetsOrganizations"></div>
                </div>
            </script><!-- idKoTemplate_ScdlOrganizations_View -->

            <script type="text/html" id="idKoTemplate_ScdlLicense_View">
                <div class="classScdlAssetsLicense">
                    <h3>
                        License:
                        <button data-bind="click: reinitializeLicense" class="button small red">Re-initialize License</button>
                    </h3>
                    UUID: <span data-bind="text: uuid"></span><br>
                    Name: <span data-bind="text: name"></span><br>
                    Terms: <span data-bind="text: terms"></span><br>
                    Website: <span data-bind="text: website"></span><br>
                </div>
            </script><!-- idKoTemplate_ScdlLicense_View -->

            <script type="text/html" id="idKoTemplate_ScdlLicenses_View">
                <div class="classEditAreaAssetsLicenses">
                    <h2>
                         Licenses:
                         <button data-bind="click: addLicense" class="button small green">Add License</button>
                         <button data-bind="click: removeAllLicenses" class="button small red">Remove All Licenses</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlLicense_View', foreach: licenses }" class="classScdlAssetsLicenses"></div>
                </div>
            </script><!-- idKoTemplate_ScdlLicenses_View -->


            <script type="text/html" id="idKoTemplate_ScdlCopyright_View">
                <div class="classScdlAssetsCopyright">
                    <h3>
                        Copyright:
                        <button data-bind="click: reinitializeCopyright" class="button small red">Re-initialize Copyright</button>
                    </h3>
                    UUID: <span data-bind="text: uuid"></span><br>
                    Notice: <span data-bind="text: notice"></span><br>
                </div>
            </script><!-- idKoTemplate_ScdlLicense_View -->

            <script type="text/html" id="idKoTemplate_ScdlCopyrights_View">
                <div class="classEditAreaAssetsCopyrights">
                    <h2>
                        Copyright Notices:
                        <button data-bind="click: addCopyright" class="button small green">Add Copyright</button>
                        <button data-bind="click: removeAllCopyrights" class="button small red">Remove All Copyrights</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlCopyright_View', foreach: copyrights }" class="classScdlAssetsCopyrights"></div>
                </div>
            </script><!-- idKoTemplate_ScdlLicenses_View -->

            <script type="text/html" id="idKoTemplate_ScdlMeta_View">
                <div class="classEditAreaMeta">
                    <h2>
                        Meta
                        <button data-bind="click: reinitializeMeta" class="button small red">Re-initialize Meta</button>
                    </h2>
                    UUID: <span data-bind="text: uuid"></span> 
                    Revision: <span data-bind="text: revision"></span>
                    Create: <span data-bind="text: createTime"></span>
                    Update: <span data-bind="text: updateTime"></span><br>

                    Name: <span data-bind="text: name"></span>
                    Description: <span data-bind="text: description"></span><br>
                    Author: <span data-bind="text: author"></span>
                    Organization: <span data-bind="text: organization"></span><br>
                    License: <span data-bind="text: license"></span>
                    Copyright: <span data-bind="text: copyright"></span>
                    <br>
                </div>
            </script><!-- idKoTemplate_ScdlMeta -->

            <script type="text/html" id="idKoTemplate_ScdlAssets_View">
                <div class="classEditAreaAssets">
                    <h2>
                        Assets
                        <button data-bind="click: removeAllAssets" class="button small red">Remove All Assets</button>
                    </h2>
                    <span data-bind="template: { name: 'idKoTemplate_ScdlPeople_View' }"></span>
                    <span data-bind="template: { name: 'idKoTemplate_ScdlOrganizations_View' }"></span>
                    <span data-bind="template: { name: 'idKoTemplate_ScdlLicenses_View' }"></span>
                    <span data-bind="template: { name: 'idKoTemplate_ScdlCopyrights_View' }"></span>
                </div>
            </script>


            <script type="text/html" id="idKoTemplate_ScdlType_View">
                <div class="classScdlType">
                    <h3>
                        Type <span data-bind="text: $index"></span>:
                        <button data-bind="click: resetType" class="button small red">Reset Type</button>
                    </h3>
                    <span data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></span>
                    Descriptor: <span data-bind="text: descriptor"></span><br>
                </div>
            </script><!-- idKoTemplate_ScdlType_View -->


            <script type="text/html" id="idKoTemplate_ScdlTypes_View">
                <h2>
                    Types:
                    <button data-bind="click: addType" class="button small green">Add Type</button>
                    <button data-bind="click: removeAllTypes" class="button small red">Remove All Types</button>
                </h2>
                <div data-bind="template: { name: 'idKoTemplate_ScdlType_View', foreach: types }" class="classScdlTypes"></div>
            </script><!-- idKoTemplate_ScdlTypes_View -->


           <script type="text/html" id="idKoTemplate_ScdlMachineStateEnter_View">
               State Enter Action: <span data-bind="text: enterAction"></span>
           </script>

           <script type="text/html" id="idKoTemplate_ScdlMachineStateExit_View">
               State Exit Action: <span data-bind="text: exitAction"></span>
           </script>

            <script type="text/html" id="idKoTemplate_ScdlMachineState_View">
                <div class="classScdlMachineState">
                    <h4>
                        State <span data-bind="text: $index"></span>:
                        <button data-bind="click: reinitializeState" class="button small red">Re-initialize State</button>
                    </h4>
                    <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStateEnter_View' }" class="classScdlMachineStateEnter"></div>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStateExit_View' }" class="classScdlMachineStateExit"></div>
                </div>
            </script><!-- idKoTemplate_ScdlMachineState_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachineStates_View">
                <div class="classEditAreaMachineStates">
                    <h3>
                        States:
                        <button data-bind="click: addState" class="button small green">Add State</button>
                        <button data-bind="click: removeAllStates" class="button small red">Remove All States</button>
                    </h3>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineState_View', foreach: states }" class="classScdlMachineStates"></div>
                </div>
            </script><!-- idKoTemplate_ScdlMachineStates -->

            <script type="text/html" id="idKoTemplate_ScdlMachineTransitionVector_View">
                <div class="classScdlMachineTransitionVector">
                    <h5>Vector <span data-bind="text: $index"></span>:</h5>
                    Next State: <span data-bind="text: nextState"></span><br>
                    Condition: <span data-bind="text: expression"></span><br>
                </div>
            </script><!-- idKoTemplate_ScdlMachineTransitionVector_View -->

            <script type="text/html" id="idKoTemplate_ScdlMachineTransition_View">
                <div class="classScdlMachineTransition">
                    <h4>
                        State Transition <span data-bind="text: $index"></span>:
                        <button data-bind="click: reinitializeTransition" class="button small red">Re-initialize Transition</button>
                    </h4>
                    Start State: <span data-bind="text: startState"></span><br>
                    <div class="classEditAreaMachineTransitionVectors">
                        <h4>
                            Vectors:
                            <button data-bind="click: addVector" class="button small green">Add Vector</button>
                            <button data-bind="click: removeAllVectors" class="button small red">Remove All Vectors</button>
                        </h4>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineTransitionVector_View', foreach: vectors }"></div>
                    </div>
                </div>
            </script><!-- idKoTemplate_ScdlMachineTransition_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachineTransitions_View">
                <div class="classEditAreaMachineTransitions">
                    <h3>
                       Transitions:
                       <button data-bind="click: addTransition" class="button small green">Add Transition</button>
                       <button data-bind="click: removeAllTransitions" class="button small red">Remove All Transitions</button>
                    </h3>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineTransition_View', foreach: transitions}" class="classScdlMachineTransitions"></div>
                </div>
            </script>


            <script type="text/html" id="idKoTemplate_ScdlMachinePin_View">
                <div class="classScdlMachinePin">
                    <h5>
                        <span data-bind="text: direction"></span> Pin <span data-bind="text: $index "></span>:
                        <button data-bind="click: reinitializePin" class="button small red">Re-initialize Pin</button>
                    </h5>
                    <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
                    Data type: <span data-bind="text: typeRef"></span><br>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePin_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachineInputPins_View">
                <div class="classEditAreaMachineInputPins">
                    <h4>
                        Input Pins:
                        <button data-bind="click: addInputPin" class="button small green">Add Input Pin</button>
                        <button data-bind="click: removeAllInputPins" class="button small red">Remove All Input Pins</button>
                    </h4>
                    <div class="classScdlMachineInputPins">
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: inputPins }"></div>
                    </div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachineOutputPins_View">
                <div class="classEditAreaMachineOutputPins">
                    <h4>
                        Output Pins:
                        <button data-bind="click: addOutputPin"  class="button small green">Add Output Pin</button>
                        <button data-bind="click: removeAllOutputPins" class="button small red">Remove All Output Pins</button>
                    </h4>
                    <div class="classScdlMachineOutputPins">
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: outputPins }"></div>
                    </div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachinePins_View">
                <div class="classEditAreaMachinePins">
                    <h3>
                        Pins:
                        <button data-bind="click: removeAllPins" class="button small red">Remove All Pins</button>
                    </h3>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineInputPins_View' }" class="classEditAreaMachineInputPins"></div>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineOutputPins_View' }" class="classEditAreaMachineOutputPins"></div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachines_View">
                <h2>
                    Machines:
                    <button data-bind="click: addMachine" class="button small green">Add Machine</button>
                    <button data-bind="click: removeAllMachines"  class="button small red">Remove All Machines</button>
                </h2> 
                <div data-bind="foreach: machines" class="classScdlMachines">
                    <div class="classScdlMachine">
                        <h3>
                            Machine <span data-bind="text: $index"></span>:
                            <button data-bind="click: reinitializeMachine" class="button small red">Re-initialize Machine</button>
                        </h3>
                        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePins_View' }"></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStates_View' }"></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineTransitions_View' }"></div>
                    </div><!-- classScdlMachine -->
                </div><!-- classScdlMachines -->
            </script><!-- idKoTemplate_ScdlMachiens_View -->


            <script type="text/html" id="idKoTemplate_ScdlSystem_View">
                <h3>
                    System <span data-bind="text: $index"></span>:
                </h3>
            </script><!-- idKoTemplate_ScdlSystem_View -->


            <script type="text/html" id="idKoTemplate_ScdlSystems_View">
                <h2>
                    Systems
                    <button data-bind="click: addSystem"  class="button small green">Add System</button>
                    <button data-bind="click: removeAllSystems"  class="button small red">Remove All Systems</button>
                </h2>
                <div data-bind="template: { name: 'idKoTemplate_ScdlSystem_View', foreach: systems }" class="classScdlSystems"></div>
            </script>






            </div><!-- idKoTemplates -->



            <!-- SCDL HTML VIEW DEFINITION -->

            <div id="idSchemaAppView">

                <div id="idJSONSourceViewer" data-bind="with: scdlHost">
                    <strong>SCDL Catalogue <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></strong>
                    <pre data-bind="text: toJSON"></pre>
                </div>

                <h1>#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} (#{appReleasePhase})</h1>

                <h2>Thanks for checking out the #{appName} application! This is a <u>#{appReleasePhase}</u> deployment for testing.</h2>

                <p>
                    [ Main: <a href="#{appPackagePublisherUrl}" title="Visit #{appPackagePublisher}">#{appPackagePublisher}</a> ]
                    [ Blog: <a href="#{appBlogUrl}" title="Visit the #{appBlogName}">#{appBlogName}</a> ]
                    [ GitHub: <a href="#{appGitHubRepoUrl}" title="#{appPackagePublisher} #{appName} Git Repo">#{appGitHubRepoName}</a> ]
                </p>

                <p>What you're seeing here is the Soft Circuit Description Language (SCDL pronounced "scuddle") data model bound into the
                DOM using Knockout.js. If you're interested in SCDL, I've written a bit about the subject on the #{appBlogName}. Expect
                dozens of articles on SCDL once this application is functional.</p>

                <p>If you're primarily interested in the HTML5 aspects of this project see my personal blog where I've been writing regularly
                on the subject. <a href="http://blog.chrisrussell.net" title="Chris' blog">blog.chrisrussell.net</a>.</p>

                <p>You can mess around with the buttons at this point and start to get a sense for what types
                of entities can be modeled using SCDL. Note that as you add/remove model entities, the JSON
                that comprises your SCDL catalogue is dynamically updated.</p>

                <p>Once the data model is complete, I'll begin exposing the SCDL models via interactive SVG visualizations. Stay tuned,
                I think this is going to be cool...</p>


                <div class="classScdlCatalogueHost" data-bind="with: scdlHost">
                    <h2>Catalogue <button data-bind="click: reinitializeCatalogue" class="button small red">Re-initialize Catalogue</button></h2>
                    <div data-bind="with: catalogueShim" class="classScdlCatalogueShim">
                        <div class="classScdlCatalogue" data-bind="with: scdl_v1_catalogue">

                            <div data-bind="with: meta">
                                <div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div>
                            </div><!-- with: meta -->
    
                            <div data-bind="with: assets">
                                <div data-bind="template: { name: 'idKoTemplate_ScdlAssets_View' }"></div>
                            </div><!-- with: assets -->

                            <div data-bind="template: { name: 'idKoTemplate_ScdlTypes_View' }" class="classEditAreaTypes"></div>
    
                            <div data-bind="template: { name: 'idKoTemplate_ScdlMachines_View' }" class="classEditAreaMachines"></div>
    
                            <div data-bind="template: { name: 'idKoTemplate_ScdlSystems_View' }" class="classEditAreaSystems"></div>

                        </div><!-- with: scdl_v1_catalogue .classScdlCatalogue -->
                    </div><!-- with: catalogueShim .classScdlCatalogueShim-->
                </div><!-- classScdlCatalogHost -->
            </div>
            """)





            @

        catch exception
            Console.messageError(exception)

