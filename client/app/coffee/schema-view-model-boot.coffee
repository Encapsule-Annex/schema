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

    parentJN = undefined

    constructor: ->
        @isChrome = ko.observable Encapsule.app.boot.phase1.isChrome
        @isWebKit = ko.observable Encapsule.app.boot.phase1.isWebKit
        @browserVersion = ko.observable Encapsule.app.boot.phase1.browserVersion


