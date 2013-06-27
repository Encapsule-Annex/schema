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
# schema-scdl-navigator-window-layout.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

if not (net? and net and net.brehaut? and net.brehaut)
   throw "Missing color.js library."
Color = net.brehaut.Color

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSettings = {
    jsonTag: "settings"
    label: "Settings"
    objectDescriptor: {
        mvvmType: "child"
        description: "#{appName} app settings."
    }
    subMenus: [
        {
            jsonTag: "user"
            label: "User"
            objectDescriptor: {
                mvvmType: "child"
                description: "#{appName} customizations."
            }
        } # user
        {
            jsonTag: "preferences"
            label: "Preferences"
            objectDescriptor: {
                mvvmType: "child"
                description: "App preferences."
            } # preferences objectDesciptor
            subMenus: [
                {
                    jsonTag: "app"
                    label: "App"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "#{appName} app preferences."
                    } # app objectDescriptor
                } # app 
                {
                    jsonTag: "github"
                    label: "GitHub"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "GitHub integration preferences."
                    } # github objectDescriptor
                } # github
            ] # preferences subMenus
        } # preferences
        {
            jsonTag: "advanced"
            label: "Advanced"
            objectDescriptor: {
                mvvmType: "child"
                description: "Advanced app settings."
            } # advanced objectDescriptor
            subMenus: [
                {
                    jsonTag: "baseScdlCatalogue"
                    label: "Base Catalogue"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "SCDL catalogue archetype."
                    }
                } # base SCDL catalogue
                {
                    jsonTag: "storage"
                    label: "Storage"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "App local and remote storage."
                    } # storage objectDescriptor
                    subMenus: [
                        {
                            jsonTag: "local"
                            label: "Local"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "App local storage."
                            } # local objectDescriptor
                        } # local
                        {
                            jsonTag: "remotes"
                            label: "Remotes"
                            objectDescriptor: {
                                mvvmType: "extension"
                                description: "Remote stores."
                                archetype: {
                                    jsonTag: "source"
                                    label: "Source"
                                    objectDescriptor: {
                                        mvvmType: "archetype"
                                        description: "Remove SCDL catalogue source descriptor."
                                    } # source objectDescriptor
                                } # source archetype
                            } # removes objectDescriptor
                        } # remotes
                    ] # storage submenus
                } # storage
            ] # advanced submenus
        } # advanced
    ] # settings submenus
}