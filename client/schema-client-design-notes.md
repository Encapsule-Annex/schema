
In order to keep the Schema client app organized and modular, the following
conventions for the creating of global Encapsule object namesspace and its
subobjects will be used:


Encapsule

Encapsule.code .................................... re-usable JS libs registgered here on definition
Encapsule.code.app ................................ app-specific function/class definitions

Encapsule.code.app.bootstrapper ................... class
Encpasule.code.app.Schema ......................... main Schema application class

Encapsule.code.app.viewmodel ...................... namespace object for view model classes
Encpasule.code.app.viewmodel.scdl ................. SCDL Knockout.js view model class


Encapsule.code.lib ................................ app-independent function/class definitions
Encpausle.code.lib.appcachemonitor ................ class
Encapsule.code.lib.audio .......................... namespace object for audio classes
Encapsule.code.lib.audio.blipper .................. class
Encapsule.code.lib.audio.theme .................... class
Encapsule.code.lib.audio.util ..................... class
Encapsule.code.lib.router ......................... class
Encapsule.code.lib.util ........................... class
Encapsule.code.lib.view ........................... namespace object for view classes
Encapsule.code.lib.view.logo ...................... class
Encpasule.code.lib.view.spinner ................... class

Encapsule.runtime ................................. application runtime state
Encapsule.runtime.app ............................. application runtime state 
Encapsule.runtime.boot ............................ namepsace object (filed during boot)




