import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;

class DontLosePhoneApp extends Application.AppBase {

    private var btMonitor;
    private var motionGate;
    private var gpsProximity;
    private var alarmController;
    private var updateTimer;
    private var view;

    function initialize() {
        AppBase.initialize();
        
        // Initialize modules with settings
        self.btMonitor = new BluetoothMonitor(method(:onTimeout));
        self.btMonitor.setTimeoutSeconds(Settings.getSetting(Settings.KEY_TIMEOUT, Settings.DEFAULT_TIMEOUT));
        
        self.motionGate = new MotionGate(Settings.getSetting(Settings.KEY_MOTION_GATE, Settings.DEFAULT_MOTION_GATE));
        
        self.gpsProximity = new GpsProximity(
            Settings.getSetting(Settings.KEY_GPS_ENABLED, Settings.DEFAULT_GPS_ENABLED),
            Settings.getSetting(Settings.KEY_GPS_THRESHOLD, Settings.DEFAULT_GPS_THRESHOLD)
        );
        
        self.alarmController = new AlarmController(method(:onAlarmTrigger));
        
        // Start GPS if enabled
        if (Settings.getSetting(Settings.KEY_GPS_ENABLED, Settings.DEFAULT_GPS_ENABLED)) {
            self.gpsProximity.startPositioning();
        }
    }

    // onStart() is called on application start up
    function onStart(state) {
        System.println("DLH App started");
        
        // Start update timer (check every second)
        self.updateTimer = new Timer.Timer();
        self.updateTimer.start(method(:onUpdate) as Method() as Void, 1000, true);
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
        System.println("DLH App stopped");
        
        if (self.updateTimer != null) {
            self.updateTimer.stop();
        }
        
        // Stop GPS to save battery
        if (self.gpsProximity != null) {
            self.gpsProximity.stopPositioning();
        }
    }
    
    /**
     * Main update loop - called every second
     * Implements three-tier protection logic
     */
    function onUpdate() {
        // Update modules
        self.btMonitor.update();
        self.alarmController.update();
        
        // Don't check if already alarming
        if (self.alarmController.isAlarming()) {
            return;
        }
        
        // Check if phone is connected
        if (self.btMonitor.isConnectionActive()) {
            // Phone connected - lock GPS location for future reference
            if (Settings.getSetting(Settings.KEY_GPS_ENABLED, Settings.DEFAULT_GPS_ENABLED)) {
                // Update current location (but don't trigger alarm)
                // This keeps our "last known phone location" fresh
            }
            return;
        }
        
        // Phone disconnected - check three-tier logic
        // Tier 1: Connection Timeout expired?
        var elapsed = self.btMonitor.getTimeSinceDisconnect();
        var timeout = Settings.getSetting(Settings.KEY_TIMEOUT, Settings.DEFAULT_TIMEOUT);
        
        if (elapsed < timeout) {
            return;  // Still within timeout window
        }
        
        // Tier 2: Motion Gate - is user moving?
        if (Settings.getSetting(Settings.KEY_MOTION_GATE, Settings.DEFAULT_MOTION_GATE)) {
            if (!self.motionGate.isUserMoving()) {
                System.println("No motion detected - skipping alarm");
                return;  // User not moving, don't alarm
            }
        }
        
        // Tier 3: GPS Proximity - has user walked away?
        if (Settings.getSetting(Settings.KEY_GPS_ENABLED, Settings.DEFAULT_GPS_ENABLED)) {
            if (!self.gpsProximity.hasExceededThreshold()) {
                System.println("Still near phone - skipping alarm");
                return;  // Still near phone, don't alarm
            }
        }
        
        // All tiers passed - trigger alarm
        System.println("All protection tiers triggered - ALARM!");
        self.alarmController.triggerAlarm();
    }
    
    /**
     * Called when connection timeout expires
     */
    function onTimeout() {
        System.println("Connection timeout expired");
        // Lock phone location at moment of disconnect
        if (Settings.getSetting(Settings.KEY_GPS_ENABLED, Settings.DEFAULT_GPS_ENABLED)) {
            self.gpsProximity.lockPhoneLocation();
        }
    }
    
    /**
     * Called when alarm is triggered
     */
    function onAlarmTrigger() {
        System.println("Alarm triggered - updating UI");
        if (self.view != null) {
            self.view.showAlarmScreen();
            WatchUi.requestUpdate();
        }
    }

    // Return the initial view of your application here
    function getInitialView() {
        self.view = new DontLosePhoneView(self.alarmController);
        var delegate = new DontLosePhoneDelegate(self.alarmController);
        return [ self.view, delegate ];
    }\n    \n    function getBluetoothMonitor() {\n        return self.btMonitor;\n    }\n    \n    function getAlarmController() {\n        return self.alarmController;\n    }\n\n}\n\nfunction getApp() {\n    return Application.getApp();\n}
