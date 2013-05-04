In order to keep the Schema client app organized and modular, the following
conventions for the creating of global Encapsule object namesspace and its
subobjects will be used:

Status: The class structure captured here is dated. All of the SCDL objects have been
collapsed into a declarative syntax that allows me to dynamically synthesize MVVM
instead of writing all this shit by hand. See the bottom of the page for some useful
recent information relating to this subject.

```
Encapsule

Encapsule.code ........................................................ re-usable JS libs registgered here on definition
Encapsule.code.app .................................................... app-specific function/class definitions

Encapsule.code.app.bootstrapper ....................................... class
Encpasule.code.app.Schema ............................................. main Schema application class

???? Encapsule.code.app.viewmodel .......................................... namespace object for view model classes
Encapsule.code.app.viewmodel.boot ..................................... App boot information Knockout.js view model class

Encpasule.code.app.scdl ............................................... Encapsule SCDL data model namespace

Encapsule.code.app.scdl.ObservableAssetCatalogue ...................... KO data model class
Encapsule.code.app.scdl.ObservableCatalogue ........................... KO data model class (THE UBER CONTAINER)
Encapsule.code.app.scdl.ObservableCatalogueShim ....................... KO data model class (JSON shim)
Encapsule.code.app.scdl.ObservableCatalogueShimHost ................... KO data model class (JSON shim host)
Encapsule.code.app.scdl.ObservableCommonMeta .......................... KO data model class
Encapsule.code.app.scdl.ObservableModelCatalogue ...................... KO data model class
Encapsule.code.app.scdl.ObservableSpecificationCatalogue .............. KO data model class

Encapsule.code.app.scdl.asset ......................................... SCDL asset data model namespace
Encpasule.code.app.scdl.asset.ObservablePerson ........................ KO data model class
Encapsule.code.app.scdl.asset.ObservableOrganization .................. KO data model class
Encapsule.code.app.scdl.asset.ObservableLicense ....................... KO data model class
Encapsule.code.app.scdl.asset.ObservableCopyright ..................... KO data model class

Encapsule.code.app.scdl.model ........................................  SCDL model data model namespace
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

Encapsule.code.app.scdl.specification ................................. SCDL specification data model namespace
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

Encapsule.code.app.schema ............................................. Schema app implementation code namespace

Encapsule.code.app.schema.editcontext ................................. Schema editor context

Encapsule.code.app.schema.editcontext.ObservableEditorContext ......... Top-level editor context data model class

Encapsule.runtime ..................................................... application runtime state
Encapsule.runtime.app ................................................. application runtime state 
Encapsule.runtime.boot ................................................ namepsace object (filed during boot)


SCHEMA NAVIGATOR MENU LEVEL DECLARATION OBJECT DESCRIPTOR:

type: object | objectRef | arrayRef

typeRole: archetype | extensionPoint | namespace | selectionPoint

typeOrigin: dynamic | new | parent

description: 

Currently-supported combinations:

type             typeRole          origin       mvvmType        support notes
----             --------          ------       --------        ------- -----
object           archetype         dynamic
object           archetype         new          "archetype"     yes
object           archetype         parent
object           extensionPoint    dynamic
object           extensionPoint    new
object           extensionPoint    parent
object           namespace         dynamic
object           namespace         new          "root"          yes
object           namespace         parent
object           selectionPoint    dynamic
object           selectionPoint    new
object           selectionPoint    parent


objectRef        archetype         dynamic
objectRef        archetype         new
objectRef        archetype         parent
objectRef        extensionPoint    dynamic
objectRef        extensionPoint    new
objectRef        extensionPoint    parent
objectRef        namespace         dynamic
objectRef        namespace         new
objectRef        namespace         parent       "child"         yes
objectRef        selectionPoint    dynamic      "select"        yes
objectRef        selectionPoint    new
objectRef        selectionPoint    parent


arrayRef         archetype         dynamic
arrayRef         archetype         new
arrayRef         archetype         parent
arrayRef         extensionPoint    dynamic
arrayRef         extensionPoint    new
arrayRef         extensionPoint    parent       "extension"     yes
arrayRef         namespace         dynamic
arrayRef         namespace         new
arrayRef         namespace         parent
arrayRef         selectionPoint    dynamic
arrayRef         selectionPoint    new
arrayRef         selectionPoint    parent




```




