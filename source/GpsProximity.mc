import Toybox.Position;
import Toybox.System;
import Toybox.Math;
import Toybox.Lang;

/**
 * GpsProximity - Tracks GPS location and determines if phone is nearby
 * 
 * Responsibilities:
 * - Only maintains GPS if feature is enabled in settings (battery optimization)
 * - Store last-known phone location when BT disconnects
 * - Update current position during connection (only if feature enabled)
 * - Calculate distance when connection drops
 * - Determine if threshold is exceeded
 * 
 * NOTE: GPS is resource-intensive. Only keep it active if user has GPS Proximity enabled.
 */
class GpsProximity {

    enum THRESHOLD {
        CLOSE = 10,      // 10 meters
        MEDIUM = 20,     // 20 meters
        FAR = 50         // 50 meters
    }

    private var lastPhoneLocation = null;
    private var currentLocation = null;
    private var threshold = 20;  // Default: THRESHOLD.MEDIUM
    private var gpsEnabled = true;
    private var positioningStarted = false;

    function initialize(enabled, threshold) {
        self.gpsEnabled = enabled;
        self.threshold = threshold;
    }
    
    function startPositioning() {
        if (self.gpsEnabled && !self.positioningStarted) {
            Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition) as Method(info as Position.Info) as Void);
            self.positioningStarted = true;
            System.println("GPS positioning started");
        }
    }
    
    function stopPositioning() {
        if (self.positioningStarted) {
            Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition) as Method(info as Position.Info) as Void);
            self.positioningStarted = false;
            System.println("GPS positioning stopped");
        }
    }
    
    function onPosition(info) {
        if (info.accuracy >= Position.QUALITY_USABLE) {
            self.currentLocation = info.position;
            System.println("GPS location updated");
        }
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
            var degrees = self.lastPhoneLocation.toDegrees() as Lang.Array<Lang.Double>; // <-- Cast array
            System.println("Phone location locked: " + degrees[0] + ", " + degrees[1]);
        } else {
            System.println("Phone location locked: GPS not available yet");
        }
    }

    /**
     * Calculate distance from current position to last phone location
     * Returns distance in meters, or null if cannot calculate
     */
    function getDistanceToPhone() {
        if (self.lastPhoneLocation == null || self.currentLocation == null) {
            return 0;
        }
        
        // Calculate Haversine distance
        var phoneDegrees = self.lastPhoneLocation.toDegrees() as Lang.Array<Lang.Double>;   // <-- Cast array
        var currentDegrees = self.currentLocation.toDegrees() as Lang.Array<Lang.Double>; // <-- Cast array
        
        var lat1 = phoneDegrees[0] * Math.PI / 180;
        var lon1 = phoneDegrees[1] * Math.PI / 180;
        var lat2 = currentDegrees[0] * Math.PI / 180;
        var lon2 = currentDegrees[1] * Math.PI / 180;
        
        var dLat = lat2 - lat1;
        var dLon = lon2 - lon1;
        
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(lat1) * Math.cos(lat2) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        var distance = 6371000 * c;  // Earth radius in meters
        
        return distance;
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
        if (!enabled) {
            stopPositioning();
        }
    }

}
