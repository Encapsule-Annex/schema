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

        @resetPerson = =>
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

        @resetOrganization = =>
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

        @resetLicense = =>
            @uuid(uuid.v4())
            @name(undefined)
            @terms(undefined)
            @website(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCopyright
    constructor: (notice_) ->
        @uuid = ko.observable uuid.v4()
        @notice = ko.observable notice_

        @resetCopyright = =>
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
        @revision = ko.observable 0
        @createTime = ko.observable Encapsule.code.lib.util.getEpochTime()
        @updateTime = ko.observable Encapsule.code.lib.util.getEpochTime()

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
            @createTime(Encapsule.code.lib.util.getEpochTime())
            @updateTime(Encapsule.code.lib.util.getEpochTime())



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlAssets
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

        @resetPeople = =>
            @people.removeAll()

        @resetOrganizations = =>
            @organizations.removeAll()

        @resetLicenses = =>
            @licenses.removeAll()

        @resetCopyrights = =>
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
             @meta().resetMeta()
             @descriptor(undefined)


class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin
    constructor: ->
        Console.message("ViewModel_ScdlPin::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @type = ko.observable undefined

        @resetPin = =>
            Console.message("ViewModel_ScdlPin::resetPin")
            @meta().resetMeta()
            @type(undefined)



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlTransition
    constructor: ->
        Console.message("ViewModel_ScdlTransition::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @targetState = ko.observable undefined
        @expression = ko.observable undefined

        @resetTransition = =>
            Console.message("ViewModel_ScdlTransition::resetTransition")
            @meta().resetMeta()
            @targetState(undefined)
            @expression(undefined)

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlState
    constructor: ->
        Console.message("ViewModel_ScdlState::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @enterAction = ko.observable undefined
        @exitAction = ko.observable undefined
        @transitions = ko.observableArray []

        @resetState = =>
            @meta().resetMeta()
            @enterAction(undefined)
            @exitAction(undefined)
            @transitions.removeAll()

class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachine
    constructor: ->
        Console.message("ViewModel_ScldMachine::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()
        @inputPins = ko.observableArray []
        @addInputPin = =>
            Console.message("ViewModel_ScdlMachine::addInputPin")
            @inputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin()

        @outputPins = ko.observableArray []
        @addOutputPin = =>
            Console.message("ViewModel_ScdlMachine::addOutputPin")
            @outputPins.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlPin()

        @states = ko.observableArray []

        @resetMeta = =>
            @meta().resetMeta()

        @addState = =>
            Console.message("ViewModel_ScdlMachine::addState")
            @states.push new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlMachineState()



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlSystem
    constructor: ->
        Console.message("ViewModel_ScdlSystem::constructor")
        @meta = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlEntityMeta()



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



class namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogueShim
    constructor: ->
        Console.message("ViewModel_ScdlCatalogueShim::constructor")
        @scdl_v1_catalogue = ko.observable new namespaceEncapsule_code_app_viewmodel.ViewModel_ScdlCatalogue()


        @resetCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueShim::resetCatalogue")
            try
                @scdl_v1_catalogue().resetCatalogue()
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

        @resetCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueHost::resetCatalogue")
            try
                @catalogueShim().resetCatalogue()
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

            <script type="text/html" id="idKoTemplate_ScdlPerson_View">
                <div class="classScdlAssetsPerson">
                    <h3>
                        Person:
                        <button data-bind="click: resetPerson" class="button small red">Reset Person</button>
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
                        <button data-bind="click: resetPeople" class="button small red">Reset People</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlPerson_View', foreach: people }" class="classScdlAssetsPeople"></div>
                </div>
            </script><!-- idKoTemplate_ScdlPeople_View -->


            <script type="text/html" id="idKoTemplate_ScdlOrganization_View">
                <div class="classScdlAssetsOrganization">
                    <h3>Organization:
                        <button data-bind="click: resetOrganization" class="button small red">Reset Organization</button>
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
                        <button data-bind="click: resetOrganizations" class="button small red">Reset Organizations</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlOrganization_View', foreach: organizations }" class="classScdlAssetsOrganizations"></div>
                </div>
            </script><!-- idKoTemplate_ScdlOrganizations_View -->

            <script type="text/html" id="idKoTemplate_ScdlLicense_View">
                <div class="classScdlAssetsLicense">
                    <h3>
                        License:
                        <button data-bind="click: resetLicense" class="button small red">Reset License</button>
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
                         <button data-bind="click: resetLicenses" class="button small red">Reset Licenses</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlLicense_View', foreach: licenses }" class="classScdlAssetsLicenses"></div>
                </div>
            </script><!-- idKoTemplate_ScdlLicenses_View -->


            <script type="text/html" id="idKoTemplate_ScdlCopyright_View">
                <div class="classScdlAssetsCopyright">
                    <h3>
                        Copyright:
                        <button data-bind="click: resetCopyright" class="button small red">Reset Copyright</button>
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
                        <button data-bind="click: resetCopyrights" class="button small red">Reset Copyrights</button>
                    </h2>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlCopyright_View', foreach: copyrights }" class="classScdlAssetsCopyrights"></div>
                </div>
            </script><!-- idKoTemplate_ScdlLicenses_View -->

            <script type="text/html" id="idKoTemplate_ScdlMeta_View">
                <h2>
                    Meta
                    <button data-bind="click: resetMeta" class="button small red">Reset Meta</button>
                </h2>
                UUID: <span data-bind="text: uuid"></span><br>
                Name: <span data-bind="text: name"></span><br>
                Description: <span data-bind="text: description"></span><br>
                Author: <span data-bind="text: author"></span><br>
                Organization: <span data-bind="text: organization"></span><br>
                License: <span data-bind="text: license"></span><br>
                Revision: <span data-bind="text: revision"></span><br>
                Create: <span data-bind="text: createTime"></span><br>
                Update: <span data-bind="text: updateTime"></span><br>
            </script><!-- idKoTemplate_ScdlMeta -->


            <script type="text/html" id="idKoTemplate_ScdlType_View">
                <div class="classScdlType">
                    <h3>
                        Type:
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
                    <button data-bind="click: resetTypes" class="button small red">Reset Types</button>
                </h2>
                <div data-bind="template: { name: 'idKoTemplate_ScdlType_View', foreach: types }" class="classScdlTypes"></div>
            </script><!-- idKoTemplate_ScdlTypes_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachineState_View">

            </script><!-- idKoTemplate_ScdlMachineState_View -->

            <script type="text/html" id="idKoTemplate_ScdlMachineStates_View">
                <div class="classEditAreaMachineStates">
                    <h3>States:</h3>
                </div>
            </script><!-- idKoTemplate_ScdlMachineStates -->

            <script type="text/html" id="idKoTemplate_ScdlMachineTransition_View">
            </script>

            <script type="text/html" id="idKoTemplate_ScdlMachineTransitions_View">
                <div class="classEditAreaMachineTransitions">
                    <h3>Transitions:</h3>
                </div>
            </script>

            <script type="text/html" id="idKoTemplate_ScdlMachinePin_View">
                <div class="classScdlMachinePin">
                    <h5>Pin:</h5>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePin_View -->

            <script type="text/html" id="idKoTemplate_ScdlMachineInputPins_View">
                <div class="classEditAreaMachineInputPins">
                    <h4>Input Pins:</h4>
                    <div class="classScdlMachineInputPins">
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: inputPins }"></div>
                    </div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->

            <script type="text/html" id="idKoTemplate_ScdlMachineOutputPins_View">
                <div class="classEditAreaMachineInputPins">
                    <h4>Output Pins:</h4>
                    <div class="classScdlMachineOutputPins">
                        <div data-bind="temlate: { name: 'idKoTemplate_ScdlMachinePin_View', foreach: outputPins }"></div>
                    </div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->

            <script type="text/html" id="idKoTemplate_ScdlMachinePins_View">
                <div class="classEditAreaMachinePins">
                    <h3>
                        Pins:
                    </h3>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineInputPins_View' }" class="classEditAreaMachineInputPins"></div>
                    <div data-bind="template: { name: 'idKoTemplate_ScdlMachineOutputPins_View' }" class="classEditAreaMachineOutputPins"></div>
                </div>
            </script><!-- idKoTemplate_ScdlMachinePins_View -->


            <script type="text/html" id="idKoTemplate_ScdlMachines_View">
                <h2>
                    Machines:
                    <button data-bind="click: addMachine" class="button small green">Add Machine</button>
                    <button data-bind="click: resetMachines"  class="button small red">Reset Machines</button>
                </h2> 
                <div data-bind="foreach: machines" class="classScdlMachines">
                    <div class="classScdlMachine">
                        Machine <span data-bind="text: $index"></span>:<br>
                        <div data-bind="with: meta"><div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }"></div></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineStates_View' }"></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachineTransitions_View' }"></div>
                        <div data-bind="template: { name: 'idKoTemplate_ScdlMachinePins_View' }"></div>
                    </div><!-- classScdlMachine -->
                </div><!-- classScdlMachines -->
            </script><!-- idKoTemplate_ScdlMachiens_View -->



            <!-- SCDL HTML VIEW DEFINITION -->

            <div id="idSchemaAppView">

                <div id="idJSONSourceViewer" data-bind="with: scdlHost">
                    <strong>SCDL Catalogue <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></strong>
                    <pre data-bind="text: toJSON"></pre>
                </div>

                <h1>#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} (#{appReleasePhase})</h1>

                <div class="classScdlCatalogueHost" data-bind="with: scdlHost">
                    <h2>Catalogue <button data-bind="click: resetCatalogue" class="button small red">Reset Catalogue</button></h2>
                    <div data-bind="with: catalogueShim" class="classScdlCatalogueShim">
                        <div class="classScdlCatalogue" data-bind="with: scdl_v1_catalogue">

                            <div data-bind="with: meta">
                                <div data-bind="template: { name: 'idKoTemplate_ScdlMeta_View' }" class="classEditAreaMeta"></div>
                            </div><!-- with: meta -->
    
                            <div data-bind="with: assets" class="classEditAreaAssets">
                                <h2>
                                    Assets
                                    <button data-bind="click: resetAssets" class="button small red">Reset Assets</button>
                                </h2>
                                <span data-bind="template: { name: 'idKoTemplate_ScdlPeople_View' }"></span>
                                <span data-bind="template: { name: 'idKoTemplate_ScdlOrganizations_View' }"></span>
                                <span data-bind="template: { name: 'idKoTemplate_ScdlLicenses_View' }"></span>
                                <span data-bind="template: { name: 'idKoTemplate_ScdlCopyrights_View' }"></span>
                            </div><!-- with: assets -->

                            <div data-bind="template: { name: 'idKoTemplate_ScdlTypes_View' }" class="classEditAreaTypes">
                            </div><!-- with: types -->
    
                            <div data-bind="template: { name: 'idKoTemplate_ScdlMachines_View' }" class="classEditAreaMachines">
                            </div><!-- classEditAreaMachines -->
    
                            <div class="classEditAreaSystems">
                                <h2>
                                    Systems
                                    <button data-bind="click: addSystem"  class="button small green">Add System</button>
                                    <button data-bind="click: resetSystems"  class="button small red">Reset Systems</button>
                                </h2>
                                <div data-bind="foreach: systems" class="classScdlSystems">
                                    <div class="classScdlSystem">
                                        System: <span data-bind="text: $index"></span>
                                    </div><!-- classScdlSystem -->
                                </div><!-- classScdlSystems -->
                            </div><!-- classEditAreaSystems -->

                        </div><!-- with: scdl_v1_catalogue .classScdlCatalogue -->
                    </div><!-- with: catalogueShim .classScdlCatalogueShim-->
                </div><!-- classScdlCatalogHost -->
            </div>
            """)





            @

        catch exception
            Console.messageError(exception)

