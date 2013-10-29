###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------



------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.onm = Encapsule.code.lib.onm? and Encapsule.code.lib.onm or @Encapsule.code.lib.onm = {}


Encapsule.code.lib.onm.DECAddressBookSampleRawJSON = """
{
  "littleDragon": {
    "dragonEggs": {
      "8cb5e525-78bd-4ab2-ad1d-8f5152d4dfc8": {
        "revision": 63,
        "uuid": "8cb5e525-78bd-4ab2-ad1d-8f5152d4dfc8",
        "uuidRevision": "386f7285-d57b-4f5d-a3ac-908bbe191ebc",
        "namespaceType": "root",
        "jsonTag": "addressBook",
        "____label": "Address Book",
        "____description": "An address book data model.",
        "properties": {
          "userImmutable": {},
          "userMutable": {
            "9fbda3b6-91af-41e6-b0b4-6ccd41ef0ba9": {
              "uuid": "9fbda3b6-91af-41e6-b0b4-6ccd41ef0ba9",
              "jsonTag": "name",
              "value": "",
              "____type": "string",
              "____description": "A description of this address book.",
              "metaProperties": {}
            },
            "75a52571-d02a-4476-b9ec-a69f67f099b6": {
              "uuid": "75a52571-d02a-4476-b9ec-a69f67f099b6",
              "jsonTag": "description",
              "value": "",
              "____type": "string",
              "____description": "A description of this address book.",
              "metaProperties": {}
            }
          }
        },
        "metaProperties": {},
        "semanticBindings": {
          "componentKeyGenerator": "internalUuid",
          "namespaceVersioning": "disabled"
        },
        "namespaces": {
          "970fe278-a0d6-4e8f-a57d-2b425dec1ad0": {
            "revision": 56,
            "uuid": "970fe278-a0d6-4e8f-a57d-2b425dec1ad0",
            "uuidRevision": "6196da3f-0a90-4d89-b258-b7ad9149cc0d",
            "namespaceType": "extensionPoint",
            "jsonTag": "contacts",
            "____label": "Contacts",
            "____description": "A collection of contact records.",
            "properties": {
              "userImmutable": {},
              "userMutable": {}
            },
            "metaProperties": {},
            "namespaces": {
              "a0486dfa-77c4-46a8-a77f-8979ee99fdfb": {
                "revision": 54,
                "uuid": "a0486dfa-77c4-46a8-a77f-8979ee99fdfb",
                "uuidRevision": "dc316b8b-efd3-4b62-a08f-a69c0c216e9f",
                "namespaceType": "component",
                "jsonTag": "contact",
                "____label": "Contact",
                "____description": "A contact record.",
                "properties": {
                  "userImmutable": {},
                  "userMutable": {
                    "929d52c0-8541-4069-b79e-2c7f365d6ca1": {
                      "uuid": "929d52c0-8541-4069-b79e-2c7f365d6ca1",
                      "jsonTag": "nameFirst",
                      "value": "",
                      "____type": "string",
                      "____description": "The contact's first name.",
                      "metaProperties": {}
                    },
                    "70b23a99-508d-40f4-af14-7ae409b14c01": {
                      "uuid": "70b23a99-508d-40f4-af14-7ae409b14c01",
                      "jsonTag": "nameLast",
                      "value": "",
                      "____type": "string",
                      "____description": "The contact's last name.",
                      "metaProperties": {}
                    }
                  }
                },
                "metaProperties": {},
                "namespaces": {
                  "9ade2db8-6979-4c7e-95d6-b57c225530dc": {
                    "revision": 26,
                    "uuid": "9ade2db8-6979-4c7e-95d6-b57c225530dc",
                    "uuidRevision": "e8e9f0f1-01b3-4717-8eee-acf7b1f87ec2",
                    "namespaceType": "extensionPoint",
                    "jsonTag": "phoneNumbers",
                    "____label": "Phone Numbers",
                    "____description": "A collection of phone numbers for this contact.",
                    "properties": {
                      "userImmutable": {},
                      "userMutable": {}
                    },
                    "metaProperties": {},
                    "namespaces": {
                      "89b56048-f831-4890-92e3-624a9c83573b": {
                        "revision": 7,
                        "uuid": "89b56048-f831-4890-92e3-624a9c83573b",
                        "uuidRevision": "f8f7242c-1129-490d-b5ff-be419f59a1fc",
                        "namespaceType": "component",
                        "jsonTag": "phoneNumber",
                        "____label": "Phone Number",
                        "____description": "A phone number record.",
                        "properties": {
                          "userImmutable": {},
                          "userMutable": {
                            "d7a9cd3e-1695-4b94-acf5-cac19d2b5340": {
                              "uuid": "d7a9cd3e-1695-4b94-acf5-cac19d2b5340",
                              "jsonTag": "countryCode",
                              "value": "",
                              "____type": "telephoneCountryCode",
                              "____description": "Country code.",
                              "metaProperties": {}
                            },
                            "72b29394-7b9a-41c7-9895-14c133699d82": {
                              "uuid": "72b29394-7b9a-41c7-9895-14c133699d82",
                              "jsonTag": "areaCode",
                              "value": "",
                              "____type": "areaCode",
                              "____description": "Area code.",
                              "metaProperties": {}
                            },
                            "5039fbff-d2dd-4935-96f3-29e9b8ecd652": {
                              "uuid": "5039fbff-d2dd-4935-96f3-29e9b8ecd652",
                              "jsonTag": "phoneNumber",
                              "value": "",
                              "____type": "phoneNumber",
                              "____description": "Seven-digit phone number.",
                              "metaProperties": {}
                            }
                          }
                        },
                        "metaProperties": {},
                        "namespaces": {}
                      }
                    }
                  },
                  "ce966267-3017-4c94-98ef-c6f3d2ba6576": {
                    "revision": 13,
                    "uuid": "ce966267-3017-4c94-98ef-c6f3d2ba6576",
                    "uuidRevision": "19e531d4-f9c5-4467-bf36-4e8cf22c2b9c",
                    "namespaceType": "extensionPoint",
                    "jsonTag": "addresses",
                    "____label": "Addresses",
                    "____description": "A collection of address records for this contact.",
                    "properties": {
                      "userImmutable": {},
                      "userMutable": {}
                    },
                    "metaProperties": {},
                    "namespaces": {
                      "a37ab208-75c4-4f48-a78e-a8301a171f08": {
                        "revision": 11,
                        "uuid": "a37ab208-75c4-4f48-a78e-a8301a171f08",
                        "uuidRevision": "9e2fe5fd-b26c-41a8-8d45-54dade55c072",
                        "namespaceType": "component",
                        "jsonTag": "address",
                        "____label": "Address",
                        "____description": "An address record.",
                        "properties": {
                          "userImmutable": {},
                          "userMutable": {
                            "96d23930-9484-42b1-bdda-8815cb9f2733": {
                              "uuid": "96d23930-9484-42b1-bdda-8815cb9f2733",
                              "jsonTag": "street1",
                              "value": "",
                              "____type": "string",
                              "____description": "First line of street address.",
                              "metaProperties": {}
                            },
                            "c68f4298-8295-459b-bcd7-f24d95824361": {
                              "uuid": "c68f4298-8295-459b-bcd7-f24d95824361",
                              "jsonTag": "street2",
                              "value": "",
                              "____type": "string",
                              "____description": "Second line of street address.",
                              "metaProperties": {}
                            },
                            "6afdbd23-f1bd-4ce8-97df-ba528080fa5d": {
                              "uuid": "6afdbd23-f1bd-4ce8-97df-ba528080fa5d",
                              "jsonTag": "city",
                              "value": "",
                              "____type": "string",
                              "____description": "City/town.",
                              "metaProperties": {}
                            },
                            "c14d5f29-aac1-49e6-aaca-4da5bddd6b0b": {
                              "uuid": "c14d5f29-aac1-49e6-aaca-4da5bddd6b0b",
                              "jsonTag": "country",
                              "value": "",
                              "____type": "string",
                              "____description": "Country.",
                              "metaProperties": {}
                            },
                            "a91f66dc-55b1-4aa1-aa2e-697f53884dc2": {
                              "uuid": "a91f66dc-55b1-4aa1-aa2e-697f53884dc2",
                              "jsonTag": "zipcode",
                              "value": "",
                              "____type": "string",
                              "____description": "Zipcode.",
                              "metaProperties": {}
                            }
                          }
                        },
                        "metaProperties": {},
                        "namespaces": {}
                      }
                    }
                  },
                  "6a50815f-3910-48ee-8201-fbb093bb457e": {
                    "revision": 7,
                    "uuid": "6a50815f-3910-48ee-8201-fbb093bb457e",
                    "uuidRevision": "0cc7881a-60e0-4aea-9b48-54b1793dc024",
                    "namespaceType": "extensionPoint",
                    "jsonTag": "emails",
                    "____label": "E-Mail Addresses",
                    "____description": "A collection of e-mail addresses for this contact.",
                    "properties": {
                      "userImmutable": {},
                      "userMutable": {}
                    },
                    "metaProperties": {},
                    "namespaces": {
                      "fe4ac5be-1dbb-452c-9547-c3c14c0b9e4b": {
                        "revision": 5,
                        "uuid": "fe4ac5be-1dbb-452c-9547-c3c14c0b9e4b",
                        "uuidRevision": "860136a3-16e3-4195-af00-8b4408aa95a9",
                        "namespaceType": "component",
                        "jsonTag": "email",
                        "____label": "E-Mail Address",
                        "____description": "An e-mail address for this contact.",
                        "properties": {
                          "userImmutable": {},
                          "userMutable": {
                            "22aa3d18-ea92-4c6a-988f-0a20faa3612b": {
                              "uuid": "22aa3d18-ea92-4c6a-988f-0a20faa3612b",
                              "jsonTag": "type",
                              "value": "home",
                              "____type": "emailTypeEnum",
                              "____description": "One of 'home', 'office', 'other'...",
                              "metaProperties": {}
                            },
                            "a7fffffb-1390-40d3-89b8-547d5e22b4b5": {
                              "uuid": "a7fffffb-1390-40d3-89b8-547d5e22b4b5",
                              "jsonTag": "email",
                              "value": "",
                              "____type": "emailAddress",
                              "____description": "The contact's e-mail address.",
                              "metaProperties": {}
                            }
                          }
                        },
                        "metaProperties": {},
                        "namespaces": {}
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
"""

