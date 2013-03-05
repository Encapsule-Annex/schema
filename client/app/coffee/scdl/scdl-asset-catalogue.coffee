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

namespaceEncapsule_code_app_scdl_asset = Encapsule.code.app.scdl.asset? and Encapsule.code.app.scdl.asset or @Encapsule.code.app.scdl.asset = {}


class namespaceEncapsule_code_app_scdl_asset.ObservableAssetCatalogue
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
