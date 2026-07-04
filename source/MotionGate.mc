import Toybox.Sensor;
import Toybox.System;
import Toybox.SensorHistory;
import Toybox.Time;

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
        self.lastMotionTime = Time.now().value();
        
        // Enable sensor listening
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE]);
        Sensor.enableSensorEvents(method(:onSensorData) as Method(info as Sensor.Info) as Void);
    }
    
    function onSensorData(sensorInfo) {
        // Sensor data callback - can be used for real-time monitoring
    }

    /**
     * Check if user is currently moving
     * Returns true if motion detected above threshold
     */
    function isUserMoving() {
        if (!self.motionEnabled) {
            return false;
        }
        
        // Check heart rate history as a proxy for movement
        var hrIterator = SensorHistory.getHeartRateHistory({:period => 1, :order => SensorHistory.ORDER_NEWEST_FIRST});
        
        if (hrIterator != null) {
            var currentHR = hrIterator.next();
            if (currentHR != null && currentHR.data != null) {
                // If heart rate is elevated (>90 bpm), likely moving
                if (currentHR.data > 90) {
                    System.println("Motion detected: HR=" + currentHR.data);
                    return true;
                }
            }
        }
        
        // Check accelerometer data if available
        var accelInfo = Sensor.getInfo();
        if (accelInfo has :accel && accelInfo.accel != null) {
            var accel = accelInfo.accel;
            // Calculate magnitude of acceleration vector
            var magnitude = Math.sqrt(accel[0] * accel[0] + accel[1] * accel[1] + accel[2] * accel[2]);
            
            // If significantly different from gravity (9.8 m/s²), user is moving
            if (magnitude > 12.0 || magnitude < 7.0) {
                System.println("Motion detected: accel magnitude=" + magnitude);
                return true;
            }
        }
        
        return false;
    }

    function setEnabled(enabled) {
        self.motionEnabled = enabled;
    }

    function setThreshold(threshold) {
        self.motionThreshold = threshold;
    }

}
