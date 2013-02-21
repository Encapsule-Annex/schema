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

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceApp = Encapsule.app? and Encapsule.app or @Encapsule.app = {}
namespaceViewModel = Encapsule.app.viewmodel? and Encapsule.app.viewModel or @Encapsule.app.viewmodel = {}

class namespaceViewModel.ViewModel_AppBootInfo

    constructor: ->
        @visible = ko.observable true
        @routerSequenceNumber = ko.computed => Encapsule.app.boot.phase0.router.routerSequenceNumber()
        @routerBootLocation = ko.observable Encapsule.app.boot.phase0.router.initialLocation()
        @userAgent = ko.observable Encapsule.app.boot.phase1.userAgent
        @isChrome = ko.observable Encapsule.app.boot.phase1.isChrome
        @isWebKit = ko.observable Encapsule.app.boot.phase1.isWebKit
        @browserVersion = ko.observable Encapsule.app.boot.phase1.browserVersion
        @appCacheState = ko.observable Encapsule.app.boot.phase2.appCacheMonitorState

        @html = """
            <div id="idAppBoot">
            <div data-bind="style: { display : visible() ? 'inline' : 'none' }">
            <strong>Application Build Information</strong><br>
            Application Package Publisher: <span data-bind="text: appPackagePublisher"></span> (<span data-bind="text: appPackagePublisherUrl"></span>)<br>
            Application Package ID: <span data-bind="text: appPackageId"></span><br>
            Application Name: <span data-bind="text: appName"></span><br>
            Application Version: <span data-bind="text: appVersion"></span><br>
            Application Release Phase: <span data-bind="text: appReleasePhase"></span><br>
            Application Release: <span data-bind="text: appReleaseName"></span><br>
            Application Build Date: <span data-bind="text: appBuildTime"></span><br>
            Application Builder: <span data-bind="text: appBuilder"></span><br>
            Application Copyright: <span data-bind="text: appCopyright"></span><br>
            Application License: <span data-bind="text: appLicense"></span> (<span data-bind="text: appLicenseUrl"></span>)<br>
            Application ID: <span data-bind="text: appId"></span><br>
            Application Release ID: <span data-bind="text: appReleaseId"></span><br>
            Application Build ID: <span data-bind="text: appBuildId"></span><br>
            Application Source Code: <span data-bind="text: appGitHubRepoUrl"></span> (<span data-bind="text: appGitHubRepoName"></span> Git repository)<br>
            <br>
            <strong>Application Boot Information</strong><br>
            Bootstrapper exit status: <span data-bind="text: Encapsule.app.boot.exitStatus"></span><br>
            Current route #: <span data-bind="text: routerSequenceNumber"></span><br>
            Boot location: <span data-bind="text: routerBootLocation"></span><br>
            User Agent: <span data-bind="text: userAgent"></span><br>
            Chrome Browser: <span data-bind="text: isChrome"></span><br>
            WebKit Browser: <span data-bind="text: isWebKit"></span><br>
            Browser Version: <span data-bind="text: browserVersion"></span>
            Application cache status: <span data-bind="text: appCacheState"></span>
            </div>
            </div><!-- idAppBoot -->
            """