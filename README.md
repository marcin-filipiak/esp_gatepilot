
# GatePilot

**GatePilot** is a WiFi-based gate control system using an ESP8266 microcontroller, a PHP server backend, and an optional Android application. The gate can be operated remotely via a web interface or a mobile app.

## Features

- Remote gate control using ESP8266 and WiFi
- PHP-based API server for handling gate state
- Android application using WebView (optional)
- Web interface with password-protected login
- Gate activity logging
- Automatic gate state reset after execution

## Project Structure

```
gatepilot/
├── esp_gatepilot/        # ESP8266 microcontroller code
├── server_gatepilot/     # PHP backend with web interface and API
└── android_gatepilot/    # Android app (optional)
```

## ESP8266

The ESP8266 device connects to WiFi and periodically checks a PHP API endpoint. If the response is `"1"`, the ESP triggers the gate relay for a defined duration, simulating a button press.

### Key configuration parameters:

- WiFi SSID and password (replace in source code)
- GPIO pin for controlling the gate (default: GPIO5 / D1)
- `url`: API endpoint to check for gate status (default: `http://foo.bar/index.php?state=show`)
- `button_delay`: Time to hold the gate control pin high
- `api_delay`: Delay between API polling

## Server (PHP)

The PHP server handles:

- Displaying a simple web interface
- Protecting access via password login and cookies
- Responding to ESP8266 API requests (`state=show`)
- Resetting the gate state after activation
- Logging gate activation timestamps

### Files:

- `index.php`: Main file handling both frontend and backend logic
- `state.tmp`: Stores current gate state (`0` or `1`)
- `statistics.txt`: Logs timestamps of each gate activation
- `style.css`, `script.js`, `logo.gif`: Optional UI elements

## Android App (optional)

The Android application is a simple WebView wrapper for the PHP web interface.

### Setup:

Open `android_gatepilot/app/src/main/java/.../MainActivity.kt` and update the following line:

```kotlin
webView.loadUrl("https://SET_URL_HERE.com") // <---- SET YOUR SERVER URL HERE
```

Replace `SET_URL_HERE.com` with the actual domain or IP where your PHP server is hosted.

> **Note:** The gate can be controlled directly from a browser – the Android app is optional.

## Requirements

- ESP8266 board (e.g., NodeMCU or Wemos D1 Mini)
- Relay module connected to GPIO5 (D1)
- Web server with PHP (e.g., Apache with PHP 7+)
- (Optional) Android device

## License

This project is open-source and available under the MIT License.

