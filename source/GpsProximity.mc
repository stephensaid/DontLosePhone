import Toybox.Position;
import Toybox.System;

/**
 * GpsProximity - Tracks GPS location and determines if phone is nearby
 * 
 * Responsibilities:
 * - Store last-known phone location
 * - Update current position during connection
 * - Calculate distance when connection drops
 * - Determine if threshold is exceeded
 */
class GpsProximity {

    enum THRESHOLD {
        CLOSE = 10,      // 10 meters
        MEDIUM = 20,     // 20 meters
        FAR = 50         // 50 meters
    }

    private var lastPhoneLocation = null;
    private var currentLocation = null;
    private var threshold = THRESHOLD.MEDIUM;
    private var gpsEnabled = true;

    function initialize(enabled, threshold) {
        self.gpsEnabled = enabled;
        self.threshold = threshold;
    }

    /**
     * Update current position (call while connected to phone)
     */
    function updateLocation(location) {
        self.currentLocation = location;
    }

    /**
     * Lock the current location as last-known phone position
     */
    function lockPhoneLocation() {
        if (self.currentLocation != null) {
            self.lastPhoneLocation = self.currentLocation;
        }
    }

    /**
     * Calculate distance from current position to last phone location
     * Returns distance in meters, or null if cannot calculate
     */
    function getDistanceToPhone() {
        // TODO: Calculate distance using Haversine or similar
        // TODO: Return meters
        return 0;
    }

    /**
     * Check if user has walked past the threshold
     */
    function hasExceededThreshold() {
        if (!self.gpsEnabled || self.lastPhoneLocation == null) {
            return false;
        }
        
        var distance = self.getDistanceToPhone();
        return distance != null && distance >= self.threshold;
    }

    function setThreshold(threshold) {
        self.threshold = threshold;
    }

    function setEnabled(enabled) {
        self.gpsEnabled = enabled;
    }

}
