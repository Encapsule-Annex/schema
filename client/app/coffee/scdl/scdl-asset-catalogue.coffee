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
# schema/client/app/coffee/scdl/scdl-asset-catalogue.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableAssetCatalogue
    constructor: ->
        @meta = ko.observable new namespaceEncapsule_code_app_scdl.ObservableCommonMeta()

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
            @people.push new Encapsule.code.app.scdl.asset.ObservablePerson()

        @addOrganization = =>
            @organizations.push new Encapsule.code.app.scdl.asset.ObservableOrganization()

        @addLicense = =>
            @licenses.push new Encapsule.code.app.scdl.asset.ObservableLicense()

        @addCopyright = =>
            @copyrights.push new Encapsule.code.app.scdl.asset.ObservableCopyright()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetPeople", ( ->
    """
    <div class="classEditAreaAssetsPeople">
        <h2>People:</h2>
        <button data-bind="click: addPerson" class="button small green">Add Person</button>
        <button data-bind="click: removeAllPeople" class="button small red">Remove All People</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlAssetPerson', foreach: people }" class="classScdlAssetsPeople"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetOrganizations", ( ->
    """
    <div class="classEditAreaAssetsOrganizations">
        <h2>Organizations:</h2>
        <button data-bind="click: addOrganization" class="button small green">Add Organization</button>
        <button data-bind="click: removeAllOrganizations" class="button small red">Remove All Organizations</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlAssetOrganization', foreach: organizations }" class="classScdlAssetsOrganizations"></div>
    </div>
    """))


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetLicenses", ( ->
    """
    <div class="classEditAreaAssetsLicenses">
        <h2>Licenses:</h2>
        <button data-bind="click: addLicense" class="button small green">Add License</button>
        <button data-bind="click: removeAllLicenses" class="button small red">Remove All Licenses</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlAssetLicense', foreach: licenses }" class="classScdlAssetsLicenses"></div>
    </div>
    """))



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetCopyrights", ( ->
    """
    <div class="classEditAreaAssetsCopyrights">
        <h2>Copyright Notices:</h2>
        <button data-bind="click: addCopyright" class="button small green">Add Copyright</button>
        <button data-bind="click: removeAllCopyrights" class="button small red">Remove All Copyrights</button>
        <div data-bind="template: { name: 'idKoTemplate_ScdlAssetCopyright', foreach: copyrights }" class="classScdlAssetsCopyrights"></div>
    </div>
    """))




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetCatalogue", ( ->
    """
    <div class="classEditAreaAssets">
        <h2>Assets:</h2>
        <button data-bind="click: removeAllAssets" class="button small red">Remove All Assets</button>
        <span data-bind="template: { name: 'idKoTemplate_ScdlAssetPeople' }"></span>
        <span data-bind="template: { name: 'idKoTemplate_ScdlAssetOrganizations' }"></span>
        <span data-bind="template: { name: 'idKoTemplate_ScdlAssetLicenses' }"></span>
        <span data-bind="template: { name: 'idKoTemplate_ScdlAssetCopyrights' }"></span>
    </div>
    """))

