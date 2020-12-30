/**
* @author Danylo Kravchenko
* https://github.com/UndeadBigUnicorn
* ---
* This module introduces MPSC channels for CFML
**/
component {

    // Module Properties
    this.title = "cfchannel";
    this.author = "Danylo Kravchenko";
    this.webURL = "https://github.com/UndeadBigUnicorn";
    this.description = "MPSC channel implementation in CFML.";
    this.version = "@version.number@+@build.number@";
    // If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
    this.viewParentLookup = true;
    // If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
    this.layoutParentLookup = true;
    this.entryPoint = "cfchannel";
    this.modelNamespace = "cfchannel";
    this.cfmapping = "cfchannel";
    this.autoMapModels = false;

    /**
    * Configure
    */
    function configure() {
        settings = {};
    }

    /**
    * Fired when the module is registered and activated.
    */
    function onLoad() {
        // Map Library
        binder.map("cfchannel@cfchannel").to("#moduleMapping#.cfchannel").initWith();
    }

    /**
    * Fired when the module is unregistered and unloaded
    */
    function onUnload() {
    }

}
