#
# schema-audio-theme.coffee
#
# Based on encapsule-blipper.js library.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceSchema = Encapsule.schema? and Encapsule.schema or @Encapsule.schema = {}
namespaceWidget = Encapsule.schema.widget? and Encapsule.schema.widget or @Encapsule.schema.widget = {}


class namespaceWidget.audioTheme

    @create: (parentElement_) ->
        host = Encapsule.audio.widget.blipper.createHost(parentElement_)
        host.createBlipper "initializing", "audio/klingon_transporter_clean.mp3"
        host.createBlipper "heartbeat", "audio/doorbell.wav"
        host.createBlipper "update-complete", "audio/stng-comp-update-complete.wav"
        host.createBlipper "beep1", "audio/romulan_computerbeep1.mp3"
        host.createBlipper "beep2", "audio/romulan_computerbeep3.mp3"
        host.createBlipper "beep3", "audio/romulan_computerbeep6.mp3"
        host.createBlipper "beep4", "audio/xindi_controls02.mp3"
        host.createBlipper "blip", "audio/stng-beep-blip.wav"
        host.createBlipper "regen", "audio/borg_alcove_regen_cycle.mp3"
        host.createBlipper "regen-abort", "audio/borg_alcove_regen_cycle_abort.mp3"
        host.createBlipper "transition", "audio/alien_door01.mp3"
        

        # Return the host object
        host




