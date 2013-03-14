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
        host.createBlipper "initializing", "audio/klingon_transporter_clean.mp3"
        host.createBlipper "heartbeat", "audio/doorbell.wav"
        host.createBlipper "update-complete", "audio/stng-comp-update-complete.wav"
        host.createBlipper "beep2", "audio/romulan_computerbeep3.mp3"
        host.createBlipper "beep4", "audio/xindi_controls02.mp3"
        host.createBlipper "blip", "audio/stng-beep-blip.wav"
        host.createBlipper "regen", "audio/borg_alcove_regen_cycle.mp3"
        host.createBlipper "regen-abort", "audio/borg_alcove_regen_cycle_abort.mp3"
        host.createBlipper "transition", "audio/alien_door01.mp3"
        host.createBlipper "xindi-on", "audio/xindi_control_lights.mp3"
        host.createBlipper "xindi-off", "audio/xindi_control_lights2.mp3"
        

        # Return the host object
        host



