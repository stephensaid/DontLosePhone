import Toybox.WatchUi;
import Toybox.System;

class DontLosePhoneDelegate extends WatchUi.BehaviorDelegate {

    private var alarmController;

    function initialize(alarmController) {
        BehaviorDelegate.initialize();
        self.alarmController = alarmController;
    }

    function onKey(keyEvent) {
        System.println("Key pressed: " + keyEvent.getKey());
        
        // Only handle keys when alarm is active
        if (self.alarmController == null || !self.alarmController.isAlarming()) {
            return false;
        }
        
        var key = keyEvent.getKey();
        
        // UP button - Dismiss
        if (key == WatchUi.KEY_ENTER || key == WatchUi.KEY_UP) {
            self.alarmController.dismiss();
            WatchUi.requestUpdate();
            return true;
        }
        
        // DOWN button or bottom left - Snooze 1
        if (key == WatchUi.KEY_DOWN) {
            var snooze1 = Settings.getSetting(Settings.KEY_SNOOZE_1, Settings.DEFAULT_SNOOZE_1);
            if (snooze1 > 0) {
                self.alarmController.snooze(snooze1);
                WatchUi.requestUpdate();
            }
            return true;
        }
        
        // ESC or bottom right - Snooze 2/3 (device dependent)
        if (key == WatchUi.KEY_ESC) {
            var snooze2 = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2);
            if (snooze2 > 0) {
                self.alarmController.snooze(snooze2);
                WatchUi.requestUpdate();
            }
            return true;
        }
        
        return false;
    }
    
    function onMenu() {
        // Middle left button pressed
        if (self.alarmController != null && self.alarmController.isAlarming()) {
            var snooze2 = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2);
            if (snooze2 > 0) {
                self.alarmController.snooze(snooze2);
                WatchUi.requestUpdate();
            }
            return true;
        }
        return false;
    }
    
    function onBack() {
        // Back button - Snooze 3 (bottom right)
        if (self.alarmController != null && self.alarmController.isAlarming()) {
            var snooze3 = Settings.getSetting(Settings.KEY_SNOOZE_3, Settings.DEFAULT_SNOOZE_3);
            if (snooze3 > 0) {
                self.alarmController.snooze(snooze3);
                WatchUi.requestUpdate();
            }
            return true;
        }
        return false;
    }

}
