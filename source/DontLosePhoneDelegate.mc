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
        
        // DOWN button - Snooze 1
        if (key == WatchUi.KEY_DOWN) {
            var snooze1 = Settings.getSetting(Settings.KEY_SNOOZE_1, Settings.DEFAULT_SNOOZE_1);
            if (snooze1 > 0) {
                self.alarmController.snooze(snooze1);
                WatchUi.requestUpdate();
            }
            return true;
        }

        // ENTER/START (top-right) - Snooze 3 (optional)
        if (key == WatchUi.KEY_ENTER) {
            var snooze3Enabled = Settings.getSetting(Settings.KEY_SNOOZE_3_ENABLED, Settings.DEFAULT_SNOOZE_3_ENABLED);
            if (snooze3Enabled) {
                var snooze3 = Settings.getSetting(Settings.KEY_SNOOZE_3, Settings.DEFAULT_SNOOZE_3);
                if (snooze3 > 0) {
                    self.alarmController.snooze(snooze3);
                    WatchUi.requestUpdate();
                }
            }
            return true;
        }
        
        // ESC is handled as Back/Dismiss by onBack below.
        if (key == WatchUi.KEY_ESC) {
            return true;
        }
        
        return false;
    }
    
    function onMenu() {
        // Middle-left button - Snooze 2 (optional)
        if (self.alarmController != null) {
            if (self.alarmController.isAlarming()) {
                var snooze2Enabled = Settings.getSetting(Settings.KEY_SNOOZE_2_ENABLED, Settings.DEFAULT_SNOOZE_2_ENABLED);
                if (snooze2Enabled) {
                    var snooze2 = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2);
                    if (snooze2 > 0) {
                        self.alarmController.snooze(snooze2);
                        WatchUi.requestUpdate();
                    }
                }
                return true;
            } else {
                // DEBUG MODE: Trigger alarm for testing when not already alarming
                System.println("DEBUG: Manual alarm trigger via Menu button");
                self.alarmController.triggerAlarm();
                WatchUi.requestUpdate();
                return true;
            }
        }
        return false;
    }
    
    function onBack() {
        // Back button - Dismiss
        if (self.alarmController != null && self.alarmController.isAlarming()) {
            self.alarmController.dismiss();
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

}
