#pragma once

#include <string>

class GeoConv
{
public:
  static void LLtoUTM(double lat, double lon, double &north, double &east, std::string &zone);
  static void UTMtoLL(double north, double east, const std::string &szone, double &lat, double &lon);
};
