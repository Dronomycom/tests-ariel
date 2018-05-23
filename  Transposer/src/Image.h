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
    Point point;

    Image(const std::string &path);

    void load();
    void transpose(const Point &refPoint);
};
