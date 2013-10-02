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
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

if not (net? and net and net.brehaut? and net.brehaut)
   throw "Missing color.js library."
Color = net.brehaut.Color

Encapsule.code.app.ONMjs.SchemaAppDataSettings = {
    jsonTag: "settings"
    ____label: "Settings"
    objectDescriptor: {
        mvvmType: "child"
        description: "#{appName} app settings."
    }
    subMenus: [
        {
            jsonTag: "user"
            ____label: "User"
            objectDescriptor: {
                mvvmType: "child"
                description: "#{appName} customizations."
            }
        } # user
        {
            jsonTag: "preferences"
            ____label: "Preferences"
            objectDescriptor: {
                mvvmType: "child"
                description: "App preferences."
            } # preferences objectDesciptor
            subMenus: [
                {
                    jsonTag: "app"
                    ____label: "App"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "#{appName} app preferences."
                    } # app objectDescriptor
                } # app 
                {
                    jsonTag: "github"
                    ____label: "GitHub"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "GitHub integration preferences."
                    } # github objectDescriptor
                } # github
            ] # preferences subMenus
        } # preferences
        {
            jsonTag: "advanced"
            ____label: "Advanced"
            objectDescriptor: {
                mvvmType: "child"
                description: "Advanced app settings."
            } # advanced objectDescriptor
            subMenus: [
                {
                    jsonTag: "baseScdlCatalogue"
                    ____label: "Base Catalogue"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "SCDL catalogue archetype."
                    }
                } # base SCDL catalogue
                {
                    jsonTag: "storage"
                    ____label: "Storage"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "App local and remote storage."
                    } # storage objectDescriptor
                    subMenus: [
                        {
                            jsonTag: "local"
                            ____label: "Local"
                            objectDescriptor: {
                                mvvmType: "child"
                                description: "App local storage."
                            } # local objectDescriptor
                        } # local
                        {
                            jsonTag: "remotes"
                            ____label: "Remotes"
                            objectDescriptor: {
                                mvvmType: "extension"
                                description: "Remote stores."
                                archetype: {
                                    jsonTag: "source"
                                    ____label: "Source"
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