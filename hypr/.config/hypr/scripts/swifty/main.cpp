#include "modules/headers/swifty.h"
#include <QApplication>
#include <QStringList> 
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <map>
#include <string>

namespace fs = std::filesystem;

const char *homeEnv = std::getenv("HOME");
// Global variables defined in main.cpp
std::string BACKEND = "swww";
std::string DIRECTORY = "~/Pictures/Wallpapers/";
QStringList ARGS;

// Helper to clean up whitespace
std::string trim(const std::string &str) {
  size_t first = str.find_first_not_of(" \t\r\n");
  if (first == std::string::npos)
    return "";
  size_t last = str.find_last_not_of(" \t\r\n");
  return str.substr(first, (last - first + 1));
}

void parseConfig(const std::string &filename) {
  std::ifstream file(filename);
  if (!file.is_open())
    return;

  std::string line;
  while (std::getline(file, line)) {
    line = trim(line);
    if (line.empty() || line[0] == '#')
      continue;

    size_t sep = line.find('=');
    if (sep != std::string::npos) {
      std::string key = trim(line.substr(0, sep));
      std::string value = trim(line.substr(sep + 1));

      // 1. Handle Standard Keys (backend, dir)
      if (key == "backend") {
        // Strip quotes: "swww" -> swww
        if (value.size() >= 2 && value.front() == '"' && value.back() == '"')
          BACKEND = value.substr(1, value.size() - 2);
      } else if (key == "dir") {
        if (value.size() >= 2 && value.front() == '"' && value.back() == '"'){
          DIRECTORY = value.substr(1, value.size() - 2);
          if (DIRECTORY.at(0) == '~') {

            DIRECTORY.replace(0, 1, std::string(homeEnv));
          }
        }
      }
      // 2. Handle Special Arguments Key (using <<)
      else if (key == "arguments") {
        ARGS.clear();
        QString raw = QString::fromStdString(value);
        // Split by << delimiter
        QStringList parts = raw.split("<<", Qt::SkipEmptyParts);

        for (QString part : parts) {
          QString clean = part.trimmed();
          // Remove quotes from each token: "img" -> img
          if (clean.startsWith('"') && clean.endsWith('"')) {
            clean = clean.mid(1, clean.length() - 2);
          }
          ARGS << clean;
        }
      }
    }
  }
}

int main(int argc, char *argv[]) {
  if (!homeEnv)
    return 1; // Safety check

  fs::path configDir = fs::path(homeEnv) / ".config/swifty";
  fs::path filePath = configDir / "swifty.conf";

  // Create directory and default file if they don't exist
  if (!fs::exists(configDir)) {
    fs::create_directories(configDir);
  }

  if (!fs::exists(filePath)) {
    std::ofstream file(filePath);
    if (file.is_open()) {
      file << "backend = \"swww\"\n"
           << "dir = \"~/Pictures/Wallpapers/\"\n"
           << "arguments = \"img\" << \"WALLPATH\" << \"--transition-type\" << "
              "\"wipe\" << \"--transition-duration\" << \"1.5\"\n";
      file.close();
    }
  }
  parseConfig(filePath.string());

  QApplication app(argc, argv);
  Swifty w;
  w.show();
  return app.exec();
}
