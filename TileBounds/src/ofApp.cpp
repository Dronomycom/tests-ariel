#include "ofApp.h"

static constexpr int TILE_SIZE = 256;
static constexpr double INITIAL_RESOLUTION = 2.0 * M_PI * 6378137 / TILE_SIZE;
static constexpr double ORIGIN_SHIFT = M_PI * 6378137;

/*
 * Resolution (meters/pixel) for given zoom level (measured at Equator)
 */
double resolution(int zoom)
{
    return INITIAL_RESOLUTION / pow(2, zoom);
}

/*
 * Converts given lat/lon in WGS84 Datum to XY in Spherical Mercator EPSG:900913
 */
pair<double, double> latLonToMeters(double lat, double lon)
{
    double mx = lon * ORIGIN_SHIFT / 180;
    double my = log(tan((90 + lat) * M_PI / 360)) / (M_PI / 180);
    my *= ORIGIN_SHIFT / 180;
    
    return make_pair(mx, my);
}

/*
 * Converts XY point from Spherical Mercator EPSG:900913 to lat/lon in WGS84 Datum
 */
pair<double, double> metersToLatLon(double mx, double my)
{
    double lon = (mx / ORIGIN_SHIFT) * 180;
    double lat = (my / ORIGIN_SHIFT) * 180;
    lat = 180 / M_PI * (2 * atan(exp(lat * M_PI / 180.0)) - M_PI / 2);
    
    return make_pair(lat, lon);
}

/*
 * Converts pixel coordinates in given zoom level of pyramid to EPSG:900913
 */
pair<double, double> pixelsToMeters(double px, double py, int zoom)
{
    double res = resolution(zoom);
    double mx = px * res - ORIGIN_SHIFT;
    double my = py * res - ORIGIN_SHIFT;
    
    return make_pair(mx, my);
}

/*
 * Converts EPSG:900913 to pyramid pixel coordinates in given zoom level
 */
pair<double, double> metersToPixels(double mx, double my, int zoom)
{
    double res = resolution(zoom);
    double px = (mx + ORIGIN_SHIFT) / res;
    double py = (my + ORIGIN_SHIFT) / res;
    
    return make_pair(px, py);
}

/*
 * Returns a tile covering region in given pixel coordinates
 */
pair<int, int> pixelsToTile(double px, double py)
{
    int tx = ceil(px / TILE_SIZE) - 1;
    int ty = ceil(py / TILE_SIZE) - 1;
    
    return make_pair(tx, ty);
}

/*
 * Returns tile for given mercator coordinates
 */
pair<int, int> metersToTile(double mx, double my, int zoom)
{
    auto p = metersToPixels(mx, my, zoom);
    return pixelsToTile(p.first, p.second);
}

/*
 * Converts TMS tile coordinates to Google Tile coordinates
 */
pair<int, int> googleTile(int tx, int ty, int zoom)
{
    /*
     * Coordinate origin is moved from bottom-left to top-left corner of the extent
     */
    return make_pair(tx, (pow(2, zoom) - 1) - ty);
}

/*
 * Maximal scaledown zoom of the pyramid closest to the pixelSize
 */
int zoomForPixelSize(int pixelSize)
{
    for (int i = 0; i < 20; i++)
    {
        if (pixelSize > resolution(i))
        {
            if (i != 0)
            {
                return i - 1;
            }
            
            return 0;
        }
    }
}

int lon2tilex(double lon, int z)
{
    return floor((lon + 180.0) / 360.0 * pow(2.0, z));
}

int lat2tiley(double lat, int z)
{
    return floor((1.0 - log(tan(lat * M_PI/180.0) + 1.0 / cos(lat * M_PI/180.0)) / M_PI) / 2.0 * pow(2.0, z));
}

void ofApp::setup()
{
    double lat = 40.78675;
    double lon = -73.96275;
    int tz = 16; // Zoom level
    
    //
    
    auto m = latLonToMeters(lat, lon);
    double mx = m.first, my = m.second;

    auto t = metersToTile(mx, my, tz);
    int tx = t.first, ty = t.second;
    
    auto g = googleTile(tx, ty, tz);
    int gx = g.first, gy = g.second;
    cout << gx << " " << gy << endl;
    
    //
    
    cout << lon2tilex(lon, tz) << " " << lat2tiley(lat, tz) << endl;

    //
    
    cout << endl;
    
    auto dx = 1024 * resolution(tz);
    auto dy = 768 * resolution(tz);
    
    auto latlonTL = metersToLatLon(mx - dx * 0.5, my + dy * 0.5);
    cout << lon2tilex(latlonTL.second, tz) << " " << lat2tiley(latlonTL.first, tz) << endl;
    
    auto latlonBR = metersToLatLon(mx + dx * 0.5, my - dy * 0.5);
    cout << lon2tilex(latlonBR.second, tz) << " " << lat2tiley(latlonBR.first, tz) << endl;
    
    //
    
    cout << endl;
    
    auto tTL = metersToTile(mx - dx * 0.5, my + dy * 0.5, tz);
    auto gTL = googleTile(tTL.first, tTL.second, tz);
    cout << gTL.first << " " << gTL.second << endl;
    
    auto tBR = metersToTile(mx + dx * 0.5, my - dy * 0.5, tz);
    auto gBR = googleTile(tBR.first, tBR.second, tz);
    cout << gBR.first << " " << gBR.second << endl;
}

void ofApp::draw()
{}
