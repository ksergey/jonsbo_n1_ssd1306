// ------------------------------------------------------------
// Copyright 2023-present Sergey Kovalevich <inndie@gmail.com>
// ------------------------------------------------------------

#include <Arduino.h>
#include <U8g2lib.h>

constexpr auto kScreenWidth = 128;
constexpr auto kScreenHeight = 32;
constexpr auto kFontHeight = 12;
constexpr auto kFontWidth = 6;
constexpr auto kLinesCount = 2;
constexpr auto kOffsetY = 5;

U8G2_SSD1306_128X32_UNIVISION_1_HW_I2C u8g2(U8G2_R0);

String lines[kLinesCount];

/// Read lines from serial. Return true on redraw required.
bool updateLines() noexcept;

/// Draw "Ready" on display
void drawReady() noexcept;

/// Draw lines
void drawLines() noexcept;

void setup(void) {
  Serial.begin(115200);

  u8g2.begin();
  u8g2.setFont(u8g2_font_6x12_tr);

  drawReady();

  Serial.println("READY");
}

void loop(void) {
  if (updateLines()) {
    drawLines();
  } else {
    delay(50);
  }
}

bool updateLines() noexcept {
  bool result = false;

  // Read line and try to parse line in format:
  // <number>#<text>
  // where <number> is line position on display
  while (Serial.available() > 0) {
    auto line = Serial.readStringUntil('\n');
    if (auto const pos = line.indexOf('#'); pos != -1) {
      auto const lineNo = line.substring(0, pos).toInt();
      if (lineNo < kLinesCount) {
        lines[lineNo] = line.substring(pos + 1);
        result = true;
      }
    }
  }

  return result;
}

void drawReady() noexcept {
  u8g2.firstPage();
  do {
    u8g2.drawStr(0, kOffsetY + kFontHeight, "Ready");
  } while (u8g2.nextPage());
}

void drawLines() noexcept {
  u8g2.firstPage();
  do {
    for (int i = 0; i < kLinesCount; ++i) {
      auto const& line = lines[i];
      u8g2.drawStr(0, kOffsetY + kFontHeight * (i + 1), line.c_str());
    }
  } while (u8g2.nextPage());
}
