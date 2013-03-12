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
# schema/client/app/coffee/scdl/scdl-asset-person.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
namespaceEncapsule_code_app_scdl = Encapsule.code.app.scdl? and Encapsule.code.app.scdl or @Encapsule.code.app.scdl = {}

namespaceEncapsule_code_app_scdl_asset = Encapsule.code.app.scdl.asset? and Encapsule.code.app.scdl.asset or @Encapsule.code.app.scdl.asset = {}


class namespaceEncapsule_code_app_scdl_asset.ObservablePerson
    constructor: (nameFirst_, nameLast_, email_, website_, gitUsername_) ->
        @edit = ko.observable true
        @uuid = ko.observable uuid.v4()
        @nameFirst = ko.observable nameFirst_
        @nameLast = ko.observable nameLast_
        @email = ko.observable email_
        @website = ko.observable website_
        @gitUsername = ko.observable gitUsername_

        @toggleEdit = =>
            @edit(not @edit())

        @reinitializePerson = =>
            @uuid(uuid.v4())
            @nameFirst(undefined)
            @nameLast(undefined)
            @email(undefined)
            @website(undefined)
            @gitUsername(undefined)



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ScdlAssetPerson", ( ->
    """
    <div class="classScdlAssetPerson">
        <h3>Person:</h3>
        <button data-bind="click: reinitializePerson" class="button small red">Re-initialize Person</button>
        <button data-bind="click: toggleEdit" class="button small blue">Edit</button>
        <br>
        <span data-bind="if: edit">
            <strong>User ID:</strong> <span data-bind="text: uuid"></span><br>
            <strong>First Name:</strong> <input type="text" data-bind="value: nameFirst" /><br>
            <strong>Last Name: </strong> <input type="text" data-bind="value: nameLast" /><br>
            <strong>E-mail: </strong> <input type="email" data-bind="value: email" /><br>
            <strong>Website: </strong> <input type="url" data-bind="value: website" /><br>
            <strong>GitHub Username: </strong> <input type="text" data-bind="value: gitUsername" />
        </span>
        <span data-bind="ifnot: edit">
            <strong>User ID:</strong> <span data-bind="text: uuid"></span> 
            <strong>Name:</strong> <span data-bind="text: nameFirst"></span> <span data-bind="text: nameLast"></span>
            <strong>E-mail: </strong> <span data-bind="text: email"></span> <strong>Website:</strong> <span data-bind="text: website"></span>
            <strong>GitHub User:</strong> <span data-bind="text: gitUsername"></span>
        </span>
    </div>
    """))
