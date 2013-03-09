In order to keep the Schema client app organized and modular, the following
conventions for the creating of global Encapsule object namesspace and its
subobjects will be used:

```
Encapsule

Encapsule.code ........................................................ re-usable JS libs registgered here on definition
Encapsule.code.app .................................................... app-specific function/class definitions

Encapsule.code.app.bootstrapper ....................................... class
Encpasule.code.app.Schema ............................................. main Schema application class

???? Encapsule.code.app.viewmodel .......................................... namespace object for view model classes
Encapsule.code.app.viewmodel.boot ..................................... App boot information Knockout.js view model class

Encpasule.code.app.scdl ............................................... Encapsule SCDL client-side code namespace

Encapsule.code.app.scdl.ObservableAssetCatalogue ...................... KO data model class
Encapsule.code.app.scdl.ObservableCatalogue ........................... KO data model class (THE UBER CONTAINER)
Encapsule.code.app.scdl.ObservableCatalogueShim ....................... KO data model class (JSON shim)
Encapsule.code.app.scdl.ObservableCatalogueShimHost ................... KO data model class (JSON shim host)
Encapsule.code.app.scdl.ObservableCommonMeta .......................... KO data model class
Encapsule.code.app.scdl.ObservableModelCatalogue ...................... KO data model class
Encapsule.code.app.scdl.ObservableSpecificationCatalogue .............. KO data model class

Encapsule.code.app.scdl.asset ......................................... SCDL asset namespace
Encpasule.code.app.scdl.asset.ObservablePerson ........................ KO data model class
Encapsule.code.app.scdl.asset.ObservableOrganization .................. KO data model class
Encapsule.code.app.scdl.asset.ObservableLicense ....................... KO data model class
Encapsule.code.app.scdl.asset.ObservableCopyright ..................... KO data model class

Encapsule.code.app.scdl.model ........................................  SCDL model namespace
Encapsule.code.app.scdl.model.ObservableMachine ....................... KO data model class
Encapsule.code.app.scdl.model.ObservableMachineTransitionVector ....... KO data model class
Encapsule.code.app.scdl.model.ObservableMachineTransition ............. KO data model class
Encapsule.code.app.scdl.model.ObservableMachineState .................. KO data model class
Encapsule.code.app.scdl.model.ObservableModelInstance ................. KO data model class
Encapsule.code.app.scdl.model.ObservableNode .......................... KO data model class
Encapsule.code.app.scdl.model.ObservablePin ........................... KO data model class
Encapsule.code.app.scdl.model.ObservablePinInstance ................... KO data model class
Encapsule.code.app.scdl.model.ObservableSocket ........................ KO data model class
Encapsule.code.app.scdl.model.ObservableSocketContract ................ KO data model class
Encapsule.code.app.scdl.model.ObservableSystem ........................ KO data model class
Encapsule.code.app.scdl.model.ObservableType .......................... KO data model class

Encapsule.code.app.scdl.specification ................................. SCDL specification namespace
Encapsule.code.app.scdl.specification.ObservableSpecification.......... KO data model class (THE GRAIL)
Encapsule.code.app.scdl.specification.ObservableSystemInstance ........ KO data model class
Encapsule.code.app.scdl.specification.ObservableSocketInstanceBinder .. KO data model class

Encapsule.code.lib .................................................... app-independent function/class definitions
Encpausle.code.lib.appcachemonitor .................................... class
Encapsule.code.lib.audio .............................................. namespace object for audio classes
Encapsule.code.lib.audio.blipper ...................................... class
Encapsule.code.lib.audio.theme ........................................ class
Encapsule.code.lib.audio.util ......................................... class
Encapsule.code.lib.kohelpers .......................................... namespace object for Knockout.js helpers
Encapsule.code.lib.router ............................................. class
Encapsule.code.lib.util ............................................... class
Encapsule.code.lib.view ............................................... namespace object for view classes
Encapsule.code.lib.view.logo .......................................... class
Encpasule.code.lib.view.spinner ....................................... class

Encapsule.runtime ..................................................... application runtime state
Encapsule.runtime.app ................................................. application runtime state 
Encapsule.runtime.boot ................................................ namepsace object (filed during boot)
```




