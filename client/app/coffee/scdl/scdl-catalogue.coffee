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
# schema/client/app/coffee/scdl/scdl-catalogue.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}


class namespaceEncapsule_code_app_scdl.ObservableCatalogue
    constructor: ->

        @meta = ko.observable new Encapsule.code.app.scdl.ObservableCommonMeta()
        @assetCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableAssetCatalogue()
        @modelCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableModelCatalogue()
        @systemCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableSystemCatalogue()

        @reinitializeCatalogue = =>
            @reinitializeMeta()
            @removeAllAssets()
            @removeAllModels()
            @removeAllSystems()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllAssets = =>
            @assetCatalogue().removeAllAssets()

        @removeAllModels = =>
            @modelCatalogue().removeAllModels()

        @removeAllSystems = =>
            @systemCatalogue().removeAllSystems()


class namespaceEncapsule_code_app_scdl.ObservableCatalogueShim
    constructor: ->
        @scdl_v1_catalogue = ko.observable new namespaceEncapsule_code_app_scdl.ObservableCatalogue()

        @reinitializeCatalogue = =>
            Console.message("ViewModel_ScdlCatalogueShim::resetCatalogue")
            try
                @scdl_v1_catalogue().reinitializeCatalogue()
            catch errorException
                Console.messageError(errorException)



class namespaceEncapsule_code_app_scdl.ObservableCatalogueShimHost
    constructor: ->
        @catalogueShim = ko.observable new namespaceEncapsule_code_app_scdl.ObservableCatalogueShim()

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

