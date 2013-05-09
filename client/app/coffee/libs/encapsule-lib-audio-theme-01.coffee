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

        host.createBlipper "00a", "audio/8105__suonho__residue-signal-illcommunications-suonho.wav"
        host.createBlipper "00", "audio/12690__scuzzpuck__zippo-open.wav"
        host.createBlipper "01", "audio/16460__emmanuel__one-use-camera-clic-with-flash.wav"
        host.createBlipper "02", "audio/25003__lg__powerup.wav"
        host.createBlipper "03", "audio/25259__suonho__deconstruction-set-turn-on.wav"
        host.createBlipper "04", "audio/28854__junggle__btn044.wav"
        host.createBlipper "05", "audio/28862__junggle__btn052.wav"
        host.createBlipper "06", "audio/28988__junggle__btn178.wav"
        host.createBlipper "07", "audio/28989__junggle__btn179.wav"
        host.createBlipper "08", "audio/29037__junggle__btn227.wav"
        host.createBlipper "09", "audio/29084__junggle__btn274.wav"
        host.createBlipper "10", "audio/29092__junggle__btn282.wav"                                                     # navigator mouse click
        host.createBlipper "11", "audio/30331__erh__radio-click-7.wav"                                                  # offline indicator
        host.createBlipper "12", "audio/36106__jak-damage__digi-code-door-uncatch.wav"
        host.createBlipper "13", "audio/39562__the-bizniss__mouse-click.wav"
        host.createBlipper "13a", "audio/41116__perlssdj__bd-open.wav"
        host.createBlipper "14", "audio/42144__crescendo__zippo.wav" # long
        host.createBlipper "15", "audio/44614__rfhache__ds-fh-fanny-tones-8.wav"
        host.createBlipper "16", "audio/47950__jesterroot4__meatkick.wav"
        host.createBlipper "17", "audio/54405__korgms2000b__button-click.wav"
        host.createBlipper "18", "audio/59332__suonho__reinsamba-nightingale-song-coockoo-dobleshot-rwrk.wav"
        host.createBlipper "19", "audio/75727__benboncan__transporter-passby.wav"
        host.createBlipper "19a","audio/81494__johnlavine333__bump1.wav"
        host.createBlipper "20", "audio/90081__jivatma07__sinebd-short-w-click.wav"
        host.createBlipper "21", "audio/126698__slightlydrybeans__hit-9.wav"
        host.createBlipper "22", "audio/130789__alexsani__butane-lighter-flip-closed.wav" # short
        host.createBlipper "23", "audio/153301__felipelnv__coffee-machine-selection.wav"
        host.createBlipper "24", "audio/160756__cosmicembers__fast-swing-air-woosh.wav"
        host.createBlipper "25", "audio/162266__qubodup__cute-activation-and-exit-off-sounds.wav"
        host.createBlipper "26", "audio/166186__drminky__menu-screen-mouse-over.wav"
        host.createBlipper "27", "audio/176145__quartzporta__signal-tone-0001.wav"
        host.createBlipper "28", "audio/176891__mickmon__click-2.wav"

        # Return the host object
        host




