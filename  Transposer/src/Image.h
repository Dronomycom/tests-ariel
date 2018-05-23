#pragma once

#include <string>

class Image
{
public:
    struct Point
    {
        double x; // EAST
        double y; // NORTH
        double z; // ALT

        Point() = default;

        Point(double x, double y, double z)
        :
        x(x),
        y(y),
        z(z)
        {}
    };

    std::string path;
    std::string description;
    Point point;
    std::string zone;

    Image(const std::string &path);

    void load();
    void save();
    void transpose(const Point &refPoint);
};
