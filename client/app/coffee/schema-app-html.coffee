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
# schema-app-html.coffee
#
# Simple routines in Coffescript to write HTML to the DOM
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}

getHtml = -> $("""

<!-- Schema app runtime view -->
<div id="idSchemaAppView">

    <div id="idJSONSourceViewer" data-bind="with: scdlHost"><strong>SCDL Catalogue JSON</strong><pre data-bind="text: toJSON" /></div>

    <h1>SCDL Editor</h1>

    <div class="classScdlCatalogueHost" data-bind="with: scdlHost">

        <h2>Catalogue <button data-bind="click: resetCatalogue">Reset Catalogue</button></h2>

        <div data-bind="with: catalogueShim" class="classScdlCatalogueShim">

            <div class="classScdlCatalogue" data-bind="with: scdl_v1_catalogue">

                <div data-bind="with: meta" class="classEditAreaMeta"><h2>Meta</h2>
                    <p>
                        UUID: <span data-bind="text: uuid"></span><br>
                        Name: <span data-bind="text: name"></span><br>
                        Description: <span data-bind="text: description"></span><br>
                        Author: <span data-bind="text: author"></span><br>
                        Organization: <span data-bind="text: organization"></span><br>
                        License: <span data-bind="text: license"></span><br>
                        Revision: <span data-bind="text: revision"></span><br>
                        Create: <span data-bind="text: createTime"></span><br>
                        Update: <span data-bind="text: updateTime"></span><br>
                    </p>
                </div><!-- with: meta -->
    
                <div data-bind="with: assets" class="classEditAreaAssets">
                    <h2>Assets <button data-bind="click: resetAssets">Reset Assets</button></h2>
                    People: <span data-bind="text: people"></span><br>
                    Organizations: <span data-bind="text: organizations"></span><br>
                    Licenses: <span data-bind="text: licenses"></span><br>
                    Copyrights: <span data-bind="text: copyrights"></span><br>
                </div><!-- with: assets -->
    
                <div class="classEditAreaTypes">
                    <h2>Types <button data-bind="click: addType">Add Type</button> <button data-bind="click: resetTypes">Reset Types</button></h2>
                    <div data-bind="foreach: types" class="classScdlTypes">
                        <div class="classScdlType">
                            Type <span data-bind="text: $index"></span>
                        </div><!-- classScdlType -->
                    </div><!--classScdlTypes -->
                </div><!-- classEditAreaTypes -->
    
                <div class="classEditAreaMachines">
                    <h2>Machines <button data-bind="click: addMachine">Add Machine</button> <button data-bind="click: resetMachines">Reset Types</button></h2> 
                    <div data-bind="foreach: machines" class="classScdlMachines">
                        <div class="classScdlMachine">
                            Machine: <span data-bind="text: $index"></span>
                        </div><!-- classScdlMachine -->
                    </div><!-- classScdlMachines -->
                </div><!-- classEditAreaMachines -->
    
                <div class="classEditAreaSystems">
                    <h2>Systems <button data-bind="click: addSystem">Add System</button> <button data-bind="click: resetSystems">Reset Types</button></h2>
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

class namespaceApp.html

    @get: getHtml