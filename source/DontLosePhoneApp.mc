import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DontLosePhoneApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
        System.println("DLH App started");
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        System.println("DLH App stopped");
    }

    // Return the initial view of your application here
    function getInitialView() {
        return [ new DontLosePhoneView() ];
    }

}

function getApp() {
    return Application.getApp();
}
