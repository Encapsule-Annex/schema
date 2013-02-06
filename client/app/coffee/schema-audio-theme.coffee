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
        host.createBlipper "heartbeat", "audio/doorbell.wav"
        host.createBlipper "update-complete", "audio/stng-comp-update-complete.wav"
        host.createBlipper "beep", "audio/romulan_computerbeep3.mp3"
        host.createBlipper "blip", "audio/stng-beep-blip.wav"
        host




