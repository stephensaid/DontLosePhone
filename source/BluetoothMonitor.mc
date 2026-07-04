import Toybox.System;
import Toybox.Time;

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
    private var timeoutSeconds = 10;

    function initialize(timeoutCallback) {
        self.timeoutCallback = timeoutCallback;
        var deviceSettings = System.getDeviceSettings();
        self.isConnected = deviceSettings.phoneConnected;
        
        if (!self.isConnected) {
            self.lastDisconnectTime = Time.now().value();
        }
    }

    /**
     * Update connection state
     * Should be called regularly from main app loop
     */
    function update() {
        var deviceSettings = System.getDeviceSettings();
        var currentlyConnected = deviceSettings.phoneConnected;
        
        // Detect disconnection event
        if (self.isConnected && !currentlyConnected) {
            self.lastDisconnectTime = Time.now().value();
            System.println("BT disconnected - starting timeout");
        }
        
        // Detect reconnection event
        if (!self.isConnected && currentlyConnected) {
            self.lastDisconnectTime = null;
            System.println("BT reconnected");
        }
        
        self.isConnected = currentlyConnected;
        
        // Check if timeout expired
        if (!self.isConnected && self.lastDisconnectTime != null) {
            var elapsed = getTimeSinceDisconnect();
            if (elapsed >= self.timeoutSeconds) {
                if (self.timeoutCallback != null) {
                    self.timeoutCallback.invoke();
                }
            }
        }
    }

    function isConnectionActive() {
        return self.isConnected;
    }

    function getTimeSinceDisconnect() {
        if (self.lastDisconnectTime == null) {
            return 0;
        }
        var now = Time.now().value();
        return now - self.lastDisconnectTime;
    }
    
    function setTimeoutSeconds(seconds) {
        self.timeoutSeconds = seconds;
    }

}
