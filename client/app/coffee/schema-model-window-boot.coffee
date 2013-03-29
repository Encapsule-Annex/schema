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
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_viewmodel = Encapsule.code.app.viewmodel? and Encapsule.code.app.viewmodel or @Encapsule.code.app.viewmodel = {}

class namespaceEncapsule_code_app_viewmodel.boot

    constructor: ->
        @visible = ko.observable true

        @html = """
            <div id="idAppBootView">
            <div data-bind="style: { display : visible() ? 'inline' : 'none' }">
            <strong>Application Build Information</strong><br>
            Application Package Publisher: <span data-bind="text: appPackagePublisher"></span> (<span data-bind="text: appPackagePublisherUrl"></span>)<br>
            Application Package ID: <span data-bind="text: appPackageId"></span><br>
            Application Name: <span data-bind="text: appName"></span><br>
            Application Version: <span data-bind="text: appVersion"></span><br>
            Application Release Phase: <span data-bind="text: appReleasePhase"></span><br>
            Application Release: <span data-bind="text: appReleaseName"></span> (fun: <span data-bind="text: appReleaseNameFunUrl"></span>)<br>
            Application Build Date: <span data-bind="text: appBuildTime"></span><br>
            Application Build Cached File Count: <span data-bind="text: appBuildCacheFileCount"></span><br>
            Application Builder: <span data-bind="text: appBuilder"></span><br>
            Application Copyright: <span data-bind="text: appCopyright"></span><br>
            Application License: <span data-bind="text: appLicense"></span> (<span data-bind="text: appLicenseUrl"></span>)<br>
            Application ID: <span data-bind="text: appId"></span><br>
            Application Release ID: <span data-bind="text: appReleaseId"></span><br>
            Application Build ID: <span data-bind="text: appBuildId"></span><br>
            Application Source Code: <span data-bind="text: appGitHubRepoUrl"></span> (<span data-bind="text: appGitHubRepoName"></span> Git repository)<br>
            <br>
            <strong>Application Boot Information</strong><br>
            Bootstrapper exit status: <span data-bind="text: Encapsule.runtime.boot.exitStatus"></span><br>
            Page Entry URI: <span data-bind="text: Encapsule.runtime.boot.phase0.router.initialLocation"></span><br>
            User Agent: <span data-bind="text: Encapsule.runtime.boot.phase1.userAgent"></span><br>
            Chrome Browser: <span data-bind="text: Encapsule.runtime.boot.phase1.isChrome"></span><br>
            WebKit Browser: <span data-bind="text: Encapsule.runtime.boot.phase1.isWebKit"></span><br>
            Browser Version: <span data-bind="text: Encapsule.runtime.boot.phase1.browserVersion"></span><br>
            Application cache status: <span data-bind="text: Encapsule.runtime.boot.phase2.appCacheMonitorState"></span><br>
            Application cache race condition handled: <span data-bind="text: Encapsule.runtime.boot.phase2.appCacheRaceConditionBroken"></span><br>
            </div>
            </div><!-- idAppBoot -->
            """
