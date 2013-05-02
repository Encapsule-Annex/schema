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
# schema-window-scdl-navigator-utility-windows.cofffee
#



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorPathWindow", ( -> """

<div class="classSchemaViewModelNavigatorPathWindow">

    <div class="path">
        <span data-bind="text: currentSelectionPath"></span>
    </div>
    <br>
    <table>
    <thead><td style="width: 200px">Attribute</td><td>Value</td></thead>
    <tr><td>Label</td><td><span data-bind="with: currentlySelectedItemHost"><span data-bind="text: menuLevelObject.label"></span></span></td></tr>
    <tr><td>Description</td><td><span data-bind="with: currentlySelectedItemHost"><span data-bind="text: itemObjectDescription"></span></span></td></tr>
    <tr><td>Type</td><td><span data-bind="with: currentlySelectedItemHost"><span data-bind="text: itemObjectOrigin"></span> &bull; <span data-bind="text: itemObjectClassification"></span> &bull; <span data-bind="text: itemObjectRole"></span> &bull; <span data-bind="text: itemObjectType"></span></span></td></tr>
    <tr><td>Path</td><td><span data-bind="with: currentlySelectedItemHost"><span data-bind="text: menuLevelObject.path"></span></span></td></tr>
    </table>




</div>

"""))

