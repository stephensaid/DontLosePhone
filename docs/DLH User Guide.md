# **User Manual & Feature Guide: "Don't Lose Phone" (DLH) Garmin App**

This guide explains how the **Don't Lose Phone (DLH)** app works on your Garmin watch, detailing its intelligent behaviors, custom settings, and how to use the physical buttons on your device when an alarm triggers.

## **1\. What is DLH?**

The **DLH** app acts as an active safety tether between your Garmin watch and your paired mobile phone. The moment your watch loses its Bluetooth connection to your phone, it initiates a series of smart checks to determine if you have left your phone behind. If it confirms you are walking away without your phone, it triggers a high-vibration, high-contrast alarm on your screen.

## **2\. The Smart Protection Logic (Battery & Sanity Saver)**

Standard phone tethers trigger annoying alarms the second Bluetooth drops, even if your phone is just on the other side of a wall. The DLH app uses three tiers of smart protection to ensure it only alerts you when it actually matters, while preserving your watch's battery.

### **Tier 1: Connection Timeout**

* **How it works:** When the connection drops, the app waits for a custom number of seconds (e.g., 10 seconds) before doing anything. If the signal returns during this window, no alarm sounds.

### **Tier 2: Smart Motion Gate (Desk Mode)**

* **How it works:** If the connection drops but you are sitting completely still at your desk or resting, the watch keeps the high-power GPS sensor powered off and remains silent.  
* **The Benefit:** You won't get startled by false alarms while sitting down. The alarm sequence will only proceed if the watch's internal sensor detects that you are actively standing up and taking physical steps.

### **Tier 3: GPS Proximity Guard (Distance Check)**

* **How it works:** While your phone is safely connected, your watch constantly remembers its exact coordinates. The second the connection drops, it locks that last-connected coordinate as **Point A** (the phone's location).  
* **The Math:** Once you start walking, the watch measures the actual straight-line distance between your current position and Point A.  
* **The Trigger:** The alarm will only fire if you physically walk past your set threshold (e.g., 20 meters away). This allows you to walk to a nearby counter to pay for an espresso or grab a cup of water without your watch screaming, but protects you if you walk completely out of the area or if someone walks away with your bike.

## **3\. The Alarm Screen**

When the app determines you have truly left your phone behind, the active alarm screen takes over your watch.

* **Theme-Adaptive Design:** The screen automatically detects whether your watch is currently set to a Light or Dark theme. It draws high-contrast elements (deep blacks for night/indoors, crisp whites for outdoor sunlight) so it is instantly readable in any environment.  
* **Main Counter:** Displays a bold, real-time timer in the center of the screen, showing exactly how many minutes and seconds have elapsed since the connection was severed.  
* **Dynamic Button Guides:** Directly next to your watch's physical keys, the screen displays dynamic labels. It looks up your custom snooze times and displays them next to the keys (e.g., **"Zzz 5m"** or **"Zzz 20m"**) alongside a red **"X"** for the Dismiss button.

## **4\. Physical Button Controls**

The watch's physical buttons are divided logically to make managing an alarm intuitive:

               (Top Right Button)  
             \--\> Always DISMISS Alarm  
                        │  
                        ▼  
       ┌─────────────────────┐  
       │                     │  
\[Middle Left Button\] ────────┼─────────\> (Bottom Right Button)  
\--\> Snooze 1 (or Unset)      │  ALARM  │  \--\> Dismiss, Snooze 3, or Unset  
                             │ ACTIVE  │  
\[Bottom Left Button\] ────────┼─────────┘  
\--\> Snooze 2 (or Unset)      │                     │  
                             └─────────────────────┘

* **Top Right Button (Start/Enter): Hardlocked Dismiss**  
  * This button is your absolute safety. Pressing it *always* completely stops the alarm, silences vibrations, and returns the watch to its normal screen.  
* **Bottom Right Button (Back/Lap): Customizable Action**  
  * By default, this also acts as a **Dismiss** button (pressing either right-side button cancels the alarm).  
  * You can customize this button to act as **Snooze 3** (a long snooze), or set it to **Unset** (the watch ignores the button during an alarm to prevent accidental presses).  
* **Middle Left Button (Up/Menu): Snooze 1 (Short)**  
  * Silences the alert for a quick break (Default: 5 minutes). Can also be set to **Unset** to disable this key.  
* **Bottom Left Button (Down): Snooze 2 (Medium)**  
  * Silences the alert for a medium duration (Default: 20 minutes). Can also be set to **Unset** to disable this key.

## **5\. Settings Directory**

You can configure these preferences directly on your watch's settings menu or via the Garmin Connect Mobile app on your smartphone:

### **Core Alarm Settings**

* **Timeout:** Set how many seconds to wait after a connection drop before starting checks (Allows values up to 5 minutes).  
* **Motion Gate (On/Off):** Toggle whether the watch should stay silent when you are completely stationary.

### **Button & Snooze Configurations**

* **Middle Left Key:** Set to **Snooze 1** or **Unset**.  
* **Snooze 1 Duration:** Set the exact number of minutes for your short snooze (unrestricted range).  
* **Bottom Left Key:** Set to **Snooze 2** or **Unset**.  
* **Snooze 2 Duration:** Set the exact number of minutes for your medium snooze (unrestricted range).  
* **Bottom Right Key:** Set to **Dismiss**, **Snooze 3**, or **Unset**.  
* **Snooze 3 Duration:** Set the exact number of minutes for your long snooze (unrestricted range).

### **GPS Proximity Settings (Sub-Menu)**

* **Distance Filter (On/Off):** Toggle GPS tracking on or off. Turning this off completely disables background GPS search to maximize battery life.  
* **Proximity Threshold:** Choose the distance limit before the alarm fires:  
  * **10 Meters:** Close proximity (Great for office use).  
  * **20 Meters:** Medium proximity (Great for cafes, gym floors, or rest stops).  
  * **50 Meters:** Wide proximity (Great for outdoor athletic fields).