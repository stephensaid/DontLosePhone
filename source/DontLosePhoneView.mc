import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;

class DontLosePhoneView extends WatchUi.WatchFace {

    private var alarmController;
    private var showingAlarm = false;

    function initialize(alarmController) {
        WatchFace.initialize();
        self.alarmController = alarmController;
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
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        if (self.alarmController != null && self.alarmController.isAlarming()) {
            drawAlarmScreen(dc);
        } else {
            drawNormalWatchface(dc);
        }
    }
    
    /**
     * Draw normal watchface with time
     */
    function drawNormalWatchface(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Get current time
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$", [
            info.hour.format("%02d"),
            info.min.format("%02d")
        ]);
        
        // Draw time
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2 - 30, 
            Graphics.FONT_NUMBER_HOT, timeString, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Draw app title
        dc.drawText(width / 2, height / 2 + 30, 
            Graphics.FONT_SMALL, "Dont Lose Phone", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Show connection status
        var app = getApp();
        if (app != null) {
            var btMonitor = app.getBluetoothMonitor();
            if (btMonitor != null) {
                var statusText = btMonitor.isConnectionActive() ? "Connected" : "Disconnected";
                dc.drawText(width / 2, height - 30, 
                    Graphics.FONT_TINY, statusText, 
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }
    }
    
    /**
     * Draw alarm screen
     */
    function drawAlarmScreen(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Red background for alarm
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_RED);
        dc.clear();
        
        // Title
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 40, 
            Graphics.FONT_LARGE, "PHONE LEFT", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.drawText(width / 2, 70, 
            Graphics.FONT_LARGE, "BEHIND!", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Snooze options
        var snooze1 = Settings.getSetting(Settings.KEY_SNOOZE_1, Settings.DEFAULT_SNOOZE_1);
        var snooze2 = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2);
        var snooze3 = Settings.getSetting(Settings.KEY_SNOOZE_3, Settings.DEFAULT_SNOOZE_3);
        
        // Draw button labels
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Top button - Dismiss
        dc.drawText(width / 2, height / 2 - 20, 
            Graphics.FONT_SMALL, "UP: Dismiss", 
            Graphics.TEXT_JUSTIFY_CENTER);
        
        // Bottom left - Snooze 1
        if (snooze1 > 0) {
            dc.drawText(20, height - 40, 
                Graphics.FONT_TINY, "< " + snooze1 + "min", 
                Graphics.TEXT_JUSTIFY_LEFT);
        }
        
        // Middle left - Snooze 2
        if (snooze2 > 0) {
            dc.drawText(20, height / 2, 
                Graphics.FONT_TINY, "< " + snooze2 + "min", 
                Graphics.TEXT_JUSTIFY_LEFT);
        }
        
        // Bottom right - Snooze 3
        if (snooze3 > 0) {
            dc.drawText(width - 20, height - 40, 
                Graphics.FONT_TINY, snooze3 + "min >", 
                Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }
    
    function showAlarmScreen() {
        self.showingAlarm = true;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing any allocated
    // resources.
    function onHide() {
        System.println("DLH View hidden");
    }

}
