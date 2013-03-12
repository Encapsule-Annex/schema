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
        @modelCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableModelCatalogue()
        @specificationCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableSpecificationCatalogue()
        @assetCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableAssetCatalogue()

        @reinitializeCatalogue = =>
            @reinitializeMeta()
            @assetCatalogue().reinitializeCatalogue()
            @modelCatalogue().reinitializeCatalogue()
            @specificationCatalogue().reinitializeCatalogue()

        @reinitializeMeta = =>
            @meta().reinitializeMeta()

        @removeAllAssets = =>
            @assetCatalogue().removeAllAssets()

        @removeAllModels = =>
            @modelCatalogue().removeAllModels()

        @removeAllSpecifications = =>
            @specificationsCatalogue().removeAllSpecifications()


class namespaceEncapsule_code_app_scdl.ObservableCatalogueShim
    constructor: ->
        @scdlCatalogue = ko.observable new Encapsule.code.app.scdl.ObservableCatalogue()

        @reinitializeCatalogue = =>
            try
                @scdlCatalogue().reinitializeCatalogue()
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
            try
                @catalogueShim().reinitializeCatalogue()
            catch errorException
                Console.messageError(errorException)

        @saveJSONAsLinkHtml = ko.computed =>

            # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
            html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"





Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlCatalogueShimHost", ( ->
    """
    <div id="idJSONSourceViewer">
        <strong>SCDL Catalogue <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></strong>
        <pre data-bind="text: toJSON"></pre>
    </div>

    <h1>#{appPackagePublisher} #{appName} v#{appVersion} #{appReleaseName} (#{appReleasePhase})</h1>
    <p>
        [ Main: <a href="#{appPackagePublisherUrl}" title="Visit #{appPackagePublisher}">#{appPackagePublisher}</a> ]
        [ Blog: <a href="#{appBlogUrl}" title="Visit the #{appBlogName}">#{appBlogName}</a> ]
        [ GitHub: <a href="#{appGitHubRepoUrl}" title="#{appPackagePublisher} #{appName} Git Repo">#{appGitHubRepoName}</a> ]
    </p>

    <p><strong>Hello! This application is very much still under development and is not usable or understandable by anyone at this point.
        If you're really curious check out the <a href="#{appBlogUrl}">#{appBlogName}</a> and follow
        <a href="http://twitter.com/encapsule" title="@Encapsule">Encapsule Project on Twitter</a> for updates.
        Thanks for your interest! - <a href="http://blog.encapsule.org/author/chrisrus/">ChrisRus</a>
    </strong></p>

    <div class="classScdlCatalogueShimHost">
        <h1>SCDL Catalogue <button data-bind="click: reinitializeCatalogue" class="button small red">Re-initialize Catalogue</button></h1>
        <div data-bind="with: catalogueShim" class="classScdlCatalogueShim">
            <div data-bind="with: scdlCatalogue" class="classScdlCatalogue" >
                <div data-bind="with: meta">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div>
                </div><!-- with: meta -->
                <div data-bind="with: modelCatalogue">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlModelCatalogue' }"></div>
                </div><!-- with: modelCatalogue -->
                <div data-bind="with: specificationCatalogue">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlSpecificationCatalogue' }"></div>
                </div><!-- with: systemCatalogue -->
                <div data-bind="with: assetCatalogue">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlAssetCatalogue' }"></div>
                </div><!-- with: assetCatologue -->
            </div><!-- with: scdlCatalogue -->
        </div><!-- with: catalogueShim .classScdlCatalogueShim-->
    </div><!-- classScdlCatalogueShimHost -->
    """))

