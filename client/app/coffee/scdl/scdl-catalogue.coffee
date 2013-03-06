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





Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlCatalogueShimHost", ( ->
    """
    <div id="idJSONSourceViewer">
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

    <h2>Catalogue <button data-bind="click: reinitializeCatalogue" class="button small red">Re-initialize Catalogue</button></h2>

        <div data-bind="with: catalogueShim" class="classScdlCatalogueShim">
            <div class="classScdlCatalogue" data-bind="with: scdl_v1_catalogue">
                <div data-bind="with: meta">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlCommonMeta' }"></div>
                </div><!-- with: meta -->
                <div data-bind="with: assetCatalogue">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlAssetCatalogue' }"></div>
                </div><!-- with: assetCatologue -->
                <div data-bind="with: modelCatalogue">
                    <div data-bind="template: { name: 'idKoTemplate_ScdlModelCatalogue' }"></div>
                </div><!-- with: modelCatalogue
            </div><!-- with: scdl_v1_catalogue .classScdlCatalogue -->
        </div><!-- with: catalogueShim .classScdlCatalogueShim-->

    """))

