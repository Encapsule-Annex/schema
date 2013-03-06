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

class namespaceEncapsule_code_app_viewmodel.scdl
    constructor: ->
        try
            self = @
            self.appPath = ko.observable ""

            # cut the chord / snip /// self.scdlHost = ko.observable new Encapsule.code.app.viewmodel.ViewModel_ScdlCatalogueHost()

            self.scdlHost = ko.observable new Encapsule.code.app.scdl.ObservableCatalogueShimHost()


            @html = """

            <!-- SCDL HTML VIEW TEMPLATES -->

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


            """





            @pageHtml = $("""
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
    
                            <div data-bind="with: assetCatalogue">
                                <div data-bind="template: { name: 'idKoTemplate_ScdlAssets_View' }"></div>
                            </div><!-- with: assetCatologue -->

                            <div data-bind="with: modelCatalogue">
                                <div data-bind="template: { name: 'idKoTemplate_ModelCatalogue' }"></div>
                            </div><!-- with: modelCatalogue


                        </div><!-- with: scdl_v1_catalogue .classScdlCatalogue -->
                    </div><!-- with: catalogueShim .classScdlCatalogueShim-->
                </div><!-- classScdlCatalogHost -->
            </div>
            """)





            @

        catch exception
            Console.messageError(exception)

