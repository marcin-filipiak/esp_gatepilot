#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

const char* ssid = "wifi_ssid";
const char* password = "wifi_password";

const char* url = "http://foo.bar/index.php?state=show";
const int pin = 5; // GPIO5 (D1)
const int button_delay = 1500;
const int api_delay = 5000;

void setup() {
  pinMode(pin, OUTPUT);
  digitalWrite(pin, LOW);

  Serial.begin(115200);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.print("IP: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    WiFiClient client;   
    HTTPClient http;

    http.begin(client, url);    

    int httpCode = http.GET();

    if (httpCode == HTTP_CODE_OK) {
      String payload = http.getString();
      payload.trim();

      Serial.print("Server response: ");
      Serial.println(payload);

      if (payload == "1") {
        digitalWrite(pin, HIGH);
        delay(button_delay);
        digitalWrite(pin, LOW);
      } else {
        digitalWrite(pin, LOW);
      }
    } else {
      Serial.print("Error HTTP: ");
      Serial.println(httpCode);
    }

    http.end();
  } else {
      Serial.println("WiFi Error");

      WiFi.begin(ssid, password);
      Serial.print("Connecting to WiFi");

      while (WiFi.status() != WL_CONNECTED) {
        delay(500);
        Serial.print(".");
      }
  }

  delay(api_delay);
}
