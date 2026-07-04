import Toybox.Sensor;
import Toybox.System;

/**
 * MotionGate - Detects user motion to gate alarm triggering
 * 
 * Responsibilities:
 * - Monitor accelerometer data
 * - Detect if user is stationary or moving
 * - Only allow alarm if significant motion detected
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
