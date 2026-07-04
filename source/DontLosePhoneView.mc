import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;

class DontLosePhoneView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("Layout initialized");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be displayed on screen.
    function onShow() {
        System.println("DLH View shown");
    }

    // Update the view
    function onUpdate(dc) {
        // Set background color based on theme (light/dark)
        var backgroundColor = Graphics.COLOR_WHITE;
        var textColor = Graphics.COLOR_BLACK;
        
        dc.setColor(textColor, backgroundColor);
        dc.clear();
        
        // Display welcome message
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, 
            Graphics.FONT_LARGE, "Don't Lose Phone", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing any allocated
    // resources.
    function onHide() {
        System.println("DLH View hidden");
    }

    function onKey(key) {
        return false;
    }

}
