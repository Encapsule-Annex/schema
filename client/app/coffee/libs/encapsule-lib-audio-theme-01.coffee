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
# schema-audio-theme.coffee
#
# Based on encapsule-blipper.js library.
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_audio = Encapsule.code.lib.audio? and Encapsule.code.lib.audio or @Encapsule.code.lib.audio = {}



class Encapsule.code.lib.audio.theme

    @create: (parentElement_) ->
        host = Encapsule.code.lib.audio.blipper.createHost(parentElement_)

        host.createBlipper "analyzing","audio/83337__corsica-s__analyzing.wav"
        host.createBlipper "loading-profile", "audio/83338__corsica-s__loading-profile.wav"
        host.createBlipper "system-critical", "audio/83339__corsica-s__system-critical.wav"
        host.createBlipper "system-normal", "audio/83340__corsica-s__system-normal.wav"
        host.createBlipper "system-starting", "audio/83342__corsica-s__system-starting-up.wav"
        host.createBlipper "warning", "audio/83343__corsica-s__warning.wav"
        host.createBlipper "history-deleted", "audio/99466__corsica-s__history-deleted.wav"
        host.createBlipper "update-complete", "audio/99469__corsica-s__update-complete.wav"

        # Return the host object
        host




