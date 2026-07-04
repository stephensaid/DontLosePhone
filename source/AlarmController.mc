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
    private var snoozeTimer = null;
    // Button mapping: [Snooze1 (BottomLeft), Snooze2 (MiddleLeft), Snooze3 (BottomRight)]
    private var snoozeDurations = [5, 20, 0];  // Default: 5min, 20min, custom
    private var alarmCallbacks = [];
    private var alertType = 2;  // Default: VIBRATION_AND_SOUND (0=vibration, 1=sound, 2=both)

    function initialize() {
        // Initialize with default snooze durations
    }

    /**
     * Trigger the alarm - phone is confirmed lost
     */
    function triggerAlarm() {
        self.state = AlarmState.ALARMING;
        
        // TODO: Switch to AlarmScreen with title, dismiss button, and snooze labels
        // TODO: Trigger alert based on alertType:
        //       - 0 (VIBRATION_ONLY): Vibration pattern only
        //       - 1 (SOUND_ONLY): Audible tone only
        //       - 2 (VIBRATION_AND_SOUND): Both vibration and sound
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
        
        // TODO: Cancel any pending snooze
        // TODO: Return to normal monitoring
    }

    function isAlarming() {
        return self.state == AlarmState.ALARMING;
    }

    function setSnoozeDurations(duration1, duration2, duration3) {
        self.snoozeDurations = [duration1, duration2, duration3];
    }

    /**
     * Set the alert type (universal setting for all alerts)
     * 0 = VIBRATION_ONLY, 1 = SOUND_ONLY, 2 = VIBRATION_AND_SOUND
     */
    function setAlertType(type) {
        self.alertType = type;
    }

    function getAlertType() {
        return self.alertType;
    }

}
