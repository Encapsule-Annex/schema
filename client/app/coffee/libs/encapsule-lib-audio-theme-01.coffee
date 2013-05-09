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

        host.createBlipper "button-click-sharp", "audio/29092__junggle__btn282.wav"
        host.createBlipper "button-click-percussive", "audio/54405__korgms2000b__button-click.wav"
        host.createBlipper "mouseover", "audio/166186__drminky__menu-screen-mouse-over.wav"
        host.createBlipper "mouseover2", "audio/130789__alexsani__butane-lighter-flip-closed.wav"

        host.createBlipper "zippo-slow", "audio/42144__crescendo__zippo.wav"
        host.createBlipper "zippo-fast", "audio/12690__scuzzpuck__zippo-open.wav"

        host.createBlipper "doubleclick", "audio/39562__the-bizniss__mouse-click.wav"
        host.createBlipper "meatkick", "audio/47950__jesterroot4__meatkick.wav"

        host.createBlipper "addArchetype", "audio/153301__felipelnv__coffee-machine-selection.wav"
        host.createBlipper "addArchetype1", "audio/28988__junggle__btn178.wav"

        host.createBlipper "originServerOffline", "audio/75727__benboncan__transporter-passby.wav"
        host.createBlipper "originServerOnline", "audio/162266__qubodup__cute-activation-and-exit-off-sounds.wav"

        host.createBlipper "thump", "audio/90081__jivatma07__sinebd-short-w-click.wav"

        # Return the host object
        host




