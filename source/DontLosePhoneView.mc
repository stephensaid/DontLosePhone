import Toybox.WatchUi;
import Toybox.System;
import Toybox.Graphics;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

class DontLosePhoneView extends WatchUi.View {

    private var alarmController;

    function initialize(alarmController) {
        View.initialize();
        self.alarmController = alarmController;
    }

    // Load your resources here
    function onLayout(dc) {
        System.println("Layout initialized");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be displayed on screen.
    function onShow() {
        System.println("DLH View shown");
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        if (self.alarmController != null && self.alarmController.isAlarming()) {
            drawAlarmScreen(dc);
        } else {
            drawNormalWatchface(dc);
        }
    }
    
    /**
     * Draw normal watchface with time
     */
    function drawNormalWatchface(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Get current time
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var timeString = Lang.format("$1$:$2$", [
            info.hour.format("%02d"),
            info.min.format("%02d")
        ]);
        
        // Draw time
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 2 - 30, 
            Graphics.FONT_NUMBER_HOT, timeString, 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Draw app title
        dc.drawText(width / 2, height / 2 + 30, 
            Graphics.FONT_SMALL, "Dont Lose Phone", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Show connection status
        var app = getApp();
        if (app != null) {
            var btMonitor = app.getBluetoothMonitor();
            if (btMonitor != null) {
                var statusText = btMonitor.isConnectionActive() ? "Connected" : "Disconnected";
                dc.drawText(width / 2, height - 30, 
                    Graphics.FONT_TINY, statusText, 
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }
    }
    
    /**
     * Draw alarm screen
     */
    function drawAlarmScreen(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // Use the device default presentation: black background and white built-in fonts.
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 24, 
            Graphics.FONT_MEDIUM, "PHONE LEFT", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        dc.drawText(centerX, centerY + 8, 
            Graphics.FONT_MEDIUM, "BEHIND!", 
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        var snooze1 = Settings.getSetting(Settings.KEY_SNOOZE_1, Settings.DEFAULT_SNOOZE_1);
        var snooze2 = Settings.getSetting(Settings.KEY_SNOOZE_2, Settings.DEFAULT_SNOOZE_2);

        var radialFont = getRadialFont(22);

        if (radialFont != null) {
            var radius = ((width < height) ? width : height) / 2 - 18;
            System.println("Radial text draw: radius=" + radius);
            dc.drawRadialText(centerX, centerY, radialFont, formatDuration(snooze2),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
                180, radius, Graphics.RADIAL_TEXT_DIRECTION_CLOCKWISE);
            dc.drawRadialText(centerX, centerY, radialFont, formatDuration(snooze1),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
                210, radius, Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
            dc.drawRadialText(centerX, centerY, radialFont, "DISMISS",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER,
                0, radius, Graphics.RADIAL_TEXT_DIRECTION_COUNTER_CLOCKWISE);
            System.println("Radial text draw: complete");
        }
    }

    function getRadialFont(size) {
        var faceNames = [
            "BionicBold", "ExoSemiBold", "KosugiRegular", "NanumGothicBold",
            "NanumGothicExtraBold", "NanumGothicRegular", "NotoNaskhArabicBold",
            "NotoNaskhArabicRegular", "NotoSansArmenianBold", "NotoSansArmenianRegular",
            "NotoSansHebrewBold", "NotoSansHebrewRegular", "NotoSansSCMedium",
            "PridiRegular", "PridiRegularGarmin", "PridiSemiBoldGarmin", "RobotoBlack",
            "RobotoCondensedBold", "RobotoCondensedRegular", "RobotoCondensedRegularItalic",
            "RobotoRegular", "SakkalMajallaBold", "SakkalMajallaRoman", "Swiss721Bold",
            "Swiss721Regular", "TomorrowBold", "YantramanavRegular"
        ];

        for (var index = 0; index < faceNames.size(); index += 1) {
            var faceName = faceNames[index];
            System.println("Testing vector font: " + faceName);
            try {
                var font = Graphics.getVectorFont({:face => faceName, :size => size});
                if (font != null) {
                    System.println("Vector font loaded: " + faceName);
                    return font;
                }
                System.println("Vector font unavailable: " + faceName);
            } catch (e) {
                System.println("Vector font error: " + faceName + " - " + e.toString());
            }
        }

        System.println("No supported vector font found");
        return null;
    }

    function drawDismissIcon(dc, cx, cy, radius) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, radius);
        dc.drawLine(cx - 4, cy - 4, cx + 4, cy + 4);
        dc.drawLine(cx - 4, cy + 4, cx + 4, cy - 4);
    }

    function drawClockIcon(dc, cx, cy, radius) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, radius);
        dc.drawLine(cx, cy, cx, cy - 5);
        dc.drawLine(cx, cy, cx + 4, cy + 1);
    }

    function formatDuration(minutes) {
        if (minutes < 60) {
            return minutes + "m";
        }

        var hours = Math.floor(minutes / 60);
        var remainingMinutes = minutes % 60;
        if (remainingMinutes == 0) {
            return hours + "h";
        }

        return hours + "h" + remainingMinutes + "m";
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing any allocated
    // resources.
    function onHide() {
        System.println("DLH View hidden");
    }

}
