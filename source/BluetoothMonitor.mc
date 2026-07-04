import Toybox.Sensor;
import Toybox.System;

/**
 * BluetoothMonitor - Monitors Bluetooth connection state
 * 
 * Responsibilities:
 * - Track connection state changes
 * - Trigger timeout countdown when disconnected
 * - Invoke callbacks for connection events
 */
class BluetoothMonitor {

    private var isConnected = false;
    private var lastDisconnectTime = null;
    private var timeoutCallback = null;

    function initialize(timeoutCallback) {
        self.timeoutCallback = timeoutCallback;
        self.isConnected = true;
    }

    /**
     * Update connection state
     * Should be called regularly from main app loop
     */
    function update() {
        // TODO: Check actual Bluetooth connection state
        // TODO: Implement timeout countdown logic
        // TODO: Trigger callback when timeout expires
    }

    function isConnectionActive() {
        return self.isConnected;
    }

    function getTimeSinceDisconnect() {
        if (self.lastDisconnectTime == null) {
            return 0;
        }
        return System.getElapsedTime() - self.lastDisconnectTime;
    }

}
