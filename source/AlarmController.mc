import Toybox.Timer;
import Toybox.System;
import Toybox.WatchUi;

/**
 * AlarmController - Manages alarm state, snooze timers, and user feedback
 * 
 * Responsibilities:
 * - Control alarm on/off state
 * - Manage snooze timer durations
 * - Trigger vibrations and alerts
 * - Display alarm screen
 * - Handle snooze/dismiss actions
 */
class AlarmController {

    enum AlarmState {
        IDLE,
        CHECKING,
        ALARMING
    }

    private var state = AlarmState.IDLE;
    private var alarmStartTime = null;
    private var snoozeTimer = null;
    private var snoozeDurations = [5, 20, 0];  // Default: 5min, 20min, custom
    private var alarmCallbacks = [];

    function initialize() {
        // Initialize with default snooze durations
    }

    /**
     * Trigger the alarm - phone is confirmed lost
     */
    function triggerAlarm() {
        self.state = AlarmState.ALARMING;
        self.alarmStartTime = System.getElapsedTime();
        
        // TODO: Switch to AlarmScreen
        // TODO: Start vibration pattern
        // TODO: Log event
    }

    /**
     * Snooze alarm for specified minutes
     */
    function snooze(minutes) {
        if (self.state == AlarmState.ALARMING) {
            self.state = AlarmState.IDLE;
            
            // TODO: Set snooze timer
            // TODO: Hide alarm screen
            // TODO: Resume monitoring
        }
    }

    /**
     * Dismiss alarm completely
     */
    function dismiss() {
        self.state = AlarmState.IDLE;
        self.alarmStartTime = null;
        
        // TODO: Cancel any pending snooze
        // TODO: Return to normal monitoring
    }

    function getElapsedTime() {
        if (self.alarmStartTime == null) {
            return 0;
        }
        return System.getElapsedTime() - self.alarmStartTime;
    }

    function isAlarming() {
        return self.state == AlarmState.ALARMING;
    }

    function setSnoozeDurations(duration1, duration2, duration3) {
        self.snoozeDurations = [duration1, duration2, duration3];
    }

}
