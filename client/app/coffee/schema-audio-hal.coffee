#
# schema-audio-hal.coffee
#
# This is a little "sound schema" featuring the HAL 9000 computer
# based on encapsule-blipper.js library.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceSchema = Encapsule.schema? and Encapsule.schema or @Encapsule.schema = {}
namespaceWidget = Encapsule.schema.widget? and Encapsule.schema.widget or @Encapsule.schema.widget = {}


class namespaceWidget.hal9000

    @create: (parentElement_) ->
        host = Encapsule.audio.widget.blipper.createHost(parentElement_)

        host.createBlipper("doorbell", "audio/doorbell.wav")
        host.createBlipper("electronics", "audio/electronics025.wav")
        host.createBlipper("beep-acknowledge", "audio/stng-beep-acknowledge.wav")
        host.createBlipper("beep-alert1", "audio/stng-beep-alert1.wav")
        host.createBlipper("beep-blip", "audio/stng-beep-blip.wav")
        host.createBlipper("beep-blurble", "audio/stng-beep-blurble.wav")
        host.createBlipper("beep-high", "audio/stng-beep-high.wav")
        host.createBlipper("beep-tripple", "audio/stng-beep-tripple.wav")
        host.createBlipper("beep-unexpected", "audio/stng-beep-unexpected.wav")
        host.createBlipper("comp-awaiting-input", "audio/stng-comp-awaiting-input.wav")
        host.createBlipper("comp-emergency-power", "audio/stng-comp-emergency-power.wav")
        host.createBlipper("comp-link-established", "audio/stng-comp-link-established.wav")
        host.createBlipper("comp-update-complete", "audio/stng-comp-update-complete.wav")

        host
