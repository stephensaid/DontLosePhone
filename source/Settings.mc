import Toybox.Lang;
import Toybox.System;
import Toybox.Application;

/**
 * Settings - Manages user preferences and configuration
 * 
 * Responsibilities:
 * - Load/save user settings to device storage
 * - Provide default values
 * - Manage settings UI
 */
class Settings {
    // Alert type constants (universal setting for all alerts)
    enum AlertType {
        VIBRATION_ONLY = 0,
        SOUND_ONLY = 1,
        VIBRATION_AND_SOUND = 2
    }

    // Setting keys
    static const KEY_TIMEOUT = "dlh_timeout";
    static const KEY_MOTION_GATE = "dlh_motion_gate";
    static const KEY_GPS_ENABLED = "dlh_gps_enabled";  // CRITICAL: Controls GPS power usage
    static const KEY_GPS_THRESHOLD = "dlh_gps_threshold";
    static const KEY_SNOOZE_2_ENABLED = "dlh_snooze_2_enabled";
    static const KEY_SNOOZE_3_ENABLED = "dlh_snooze_3_enabled";
    static const KEY_SNOOZE_1 = "dlh_snooze_1";
    static const KEY_SNOOZE_2 = "dlh_snooze_2";
    static const KEY_SNOOZE_3 = "dlh_snooze_3";
    static const KEY_BTN_LEFT_MID = "dlh_btn_left_mid";
    static const KEY_BTN_LEFT_BOT = "dlh_btn_left_bot";
    static const KEY_BTN_RIGHT_BOT = "dlh_btn_right_bot";
    static const KEY_ALERT_TYPE = "dlh_alert_type";  // Universal alert setting

    // Default values
    static const DEFAULT_TIMEOUT = 10;                                // seconds
    static const DEFAULT_MOTION_GATE = true;                          // enabled
    static const DEFAULT_GPS_ENABLED = true;                          // enabled (users can disable to save battery)
    static const DEFAULT_GPS_THRESHOLD = 20;                          // meters
    static const DEFAULT_SNOOZE_1 = 5;                                // minutes
    static const DEFAULT_SNOOZE_2 = 15;                               // minutes
    static const DEFAULT_SNOOZE_3 = 30;                               // minutes 

    static const DEFAULT_SNOOZE_2_ENABLED = false;
    static const DEFAULT_SNOOZE_3_ENABLED = false;
    static const DEFAULT_ALERT_TYPE = 2;                              // AlertType.VIBRATION_AND_SOUND (0=vibration, 1=sound, 2=both)

    /**
     * Get setting value with fallback to default
     */
    static function getSetting(key, defaultValue) {
       try {
            return Application.Properties.getValue(key);
        } catch (e) {
            return defaultValue;
        }
    }

    /**
     * Save setting value
     */
    static function setSetting(key, value) {
        Application.Properties.setValue(key, value);
    }

/**
     * Get all settings as dictionary
     */
    static function getAllSettings() {
      return {
          "timeout" => getSetting(KEY_TIMEOUT, DEFAULT_TIMEOUT),
          "motionGate" => getSetting(KEY_MOTION_GATE, DEFAULT_MOTION_GATE),
          "gpsEnabled" => getSetting(KEY_GPS_ENABLED, DEFAULT_GPS_ENABLED),
          "gpsThreshold" => getSetting(KEY_GPS_THRESHOLD, DEFAULT_GPS_THRESHOLD),
          "snooze1" => getSetting(KEY_SNOOZE_1, DEFAULT_SNOOZE_1),
          "snooze2" => getSetting(KEY_SNOOZE_2, DEFAULT_SNOOZE_2),
          "snooze2Enabled" => getSetting(KEY_SNOOZE_2_ENABLED, DEFAULT_SNOOZE_2_ENABLED),
          "snooze3" => getSetting(KEY_SNOOZE_3, DEFAULT_SNOOZE_3),
          "snooze3Enabled" => getSetting(KEY_SNOOZE_3_ENABLED, DEFAULT_SNOOZE_3_ENABLED),
          "alertType" => getSetting(KEY_ALERT_TYPE, DEFAULT_ALERT_TYPE)
      } as Dictionary<String, Object>;
    }
}
