#pragma once

#include <string>

class Image
{
public:
    Image(const std::string &path);
    void load();

protected:
    std::string path;

    double lat, lon;
    double alt;

    double north, east;
    std::string zone;
};
