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
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or @Encapsule.code.app.modelview = {}

class Encapsule.code.app.modelview.SchemaBootInfoWindow
    constructor: ->

        @showDebugConsole = =>
            Console.show()

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaBootInfoWindow", ( -> """
<h1>#{appName} v#{appVersion} Diagnostic Window</h1>
<button data-bind="click: showDebugConsole" class="button small blue">#{appName} Debug Console</button>
<h2>App Boot Info</h2>
<p>
Bootstrapper exit status: <strong><span data-bind="text: Encapsule.runtime.boot.exitStatus"></span></strong><br>
Page Entry URI: <strong><span data-bind="text: Encapsule.runtime.boot.phase0.router.initialLocation"></span></strong><br>
User Agent: <strong><span data-bind="text: Encapsule.runtime.boot.phase1.userAgent"></span></strong><br>
Chrome Browser: <strong><span data-bind="text: Encapsule.runtime.boot.phase1.isChrome"></span></strong><br>
WebKit Browser: <strong><span data-bind="text: Encapsule.runtime.boot.phase1.isWebKit"></span></strong><br>
Browser Version: <strong><span data-bind="text: Encapsule.runtime.boot.phase1.browserVersion"></span></strong><br>
Application cache status: <strong><span data-bind="text: Encapsule.runtime.boot.phase2.appCacheMonitorState"></span></strong><br>
Application cache race condition handled: <strong><span data-bind="text: Encapsule.runtime.boot.phase2.appCacheRaceConditionBroken"></span></strong><br>
</p>
<h2>App Build Info</h2>
<p>
Application Package Publisher: <strong><a href="#{appPackagePublisherUrl}" target="_blank"><span data-bind="text: appPackagePublisher"></span></a></strong><br>
Application Name: <strong><span data-bind="text: appName"></span></strong><br>
Application Version: <strong><span data-bind="text: appVersion"></span></strong></strong><br>
Application Release Phase: <strong><span data-bind="text: appReleasePhase"></span></strong><br>
Application Release: <strong><a href="#{appReleaseNameFunUrl}" target="_blank"><span data-bind="text: appReleaseName"></span></a></strong><br>
Application Build Date: <strong><span data-bind="text: appBuildTime"></span></strong><br>
Application Build Cached File Count: <strong><span data-bind="text: appBuildCacheFileCount"></span></strong><br>
Application Builder: <strong><span data-bind="text: appBuilder"></span></strong><br>
Application Copyright: <strong><span data-bind="text: appCopyright"></span></strong><br>
Application License: <strong><a href="#{appLicenseUrl}" target="_blank"><span data-bind="text: appLicense"></span></a></strong><br>
Application ID: <strong><span data-bind="text: appId"></span></strong><br>
Application Release ID: <strong><span data-bind="text: appReleaseId"></span></strong><br>
Application Build ID: <strong><span data-bind="text: appBuildId"></span></strong><br>
Application Source Code: <strong><a href="#{appGitHubRepoUrl}" target="_blank"><span data-bind="text: appGitHubRepoName"></span></a> (GitHub repo)</strong><br>
</p>
<h2>App Files</h2>
<p>Use the following links to explore the deployed implementation of #{appName} v#{appVersion}:</p>
<ul>
<li><a href="./audio" target="sources">./audio/</a></li>
<li><a href="./css" target="sources">./css/</a></li>
<li><a href="./img" target="sources">./img/</a></li>
<li><a href="./js" target="sources">./js/</a></li>
<li><a href="./no-cache" target="sources">./no-cache/</a></li>
<li><a href="./scdl" target="sources">./scdl/</a></li>
</ul>
"""))
