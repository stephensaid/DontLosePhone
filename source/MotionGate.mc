import Toybox.Sensor;
import Toybox.System;

/**
 * MotionGate - Detects user motion to gate alarm triggering
 * 
 * Responsibilities:
 * - Monitor accelerometer data when phone is disconnected
 * - Detect meaningful walking cadence (not arm movement)
 * - Detect rapid speed increase (transport mode)
 * - Only allow alarm if significant motion detected
 * 
 * BATTERY NOTE: Accelerometer has low power impact compared to GPS.
 * Keep it enabled for motion detection; GPS is the primary power drain.
 */
class MotionGate {

    private var motionEnabled = true;
    private var motionThreshold = 1.5;  // Configurable threshold
    private var lastMotionTime = null;

    function initialize(enabled) {
        self.motionEnabled = enabled;
    }

    /**
     * Check if user is currently moving
     * Returns true if motion detected above threshold
     */
    function isUserMoving() {
        // TODO: Read accelerometer data
        // TODO: Calculate motion magnitude
        // TODO: Compare against threshold
        return false;
    }

    function setEnabled(enabled) {
        self.motionEnabled = enabled;
    }

    function setThreshold(threshold) {
        self.motionThreshold = threshold;
    }

}
