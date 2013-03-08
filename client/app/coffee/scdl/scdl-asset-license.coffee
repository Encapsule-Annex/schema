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
# schema/client/app/coffee/scdl/scdl-asset-license.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}

namespaceEncapsule_code_app_scdl_asset = Encapsule.code.app.scdl.asset? and Encapsule.code.app.scdl.asset or @Encapsule.code.app.scdl.asset = {}


class namespaceEncapsule_code_app_scdl_asset.ObservableLicense
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


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetLicense", ( ->
    """
    <div class="classScdlAssetLicense">
        <h3>License:</h3>
        <button data-bind="click: reinitializeLicense" class="button small red">Re-initialize License</button>
        UUID: <span data-bind="text: uuid"></span><br>
        Name: <span data-bind="text: name"></span><br>
        Terms: <span data-bind="text: terms"></span><br>
        Website: <span data-bind="text: website"></span><br>
    </div>
    """))

