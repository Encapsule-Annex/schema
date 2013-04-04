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
# schema-view-model-window-title-bar.coffee
#
# Observable view model class for the the Schema title bar window.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

class Encapsule.code.app.modelview.SchemaTitleBarWindow
    # BEGIN: \ ObservableTitleBarWindow class
    constructor: (windowManagerCallbacks_) ->
        # BEGIN: \ constructor
        try
            ###
            if not windowManagerCallbacks_? then throw "Missing window manager callbacks parameter."
            if not windowManagerCallbacks_ then throw "Missing window manager callbacks value."
            ###

            @windowManagerCallbacks = windowManagerCallbacks_

            # END: / constructor try scope
        catch exception
            throw """SchemaTitleBarWindow construction fail: #{exception}"""
        # END: / constructor
    # END: / ObservableTitleBarWindow class


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaTitleBarWindow", ( -> """
<a href="#{appPackagePublisherUrl}" target="_blank" title="#{appPackagePublisher} Homepage">
    <img src="img/core-seablue-32x32.png" alt="#{appPackagePublisher}" style="width: 32px; height: 32px; border: none; vertical-align: middle;"></a>
<span id="idTitlebarAppPublisher"><a href="#{appPackagePublisherUrl}" target="_blank" title="#{appPackagePublisher} Homepage">#{appPackagePublisher}</a></span>
<span id="idTitlebarAppName">#{appName} v#{appVersion}</span> (status: <strong>#{appReleasePhase}</strong> &bull; built: <strong> #{appBuildTime}</strong>)
"""))