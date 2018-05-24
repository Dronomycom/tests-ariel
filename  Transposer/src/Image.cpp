#include "Image.h"
#include "GeoConv.h"

#include <cmath>

#include <exiv2/exiv2.hpp>

using namespace std;

/*
 * http://dev.exiv2.org/boards/3/topics/3132?r=3134
 */
double gpsRationalToDecimal(Exiv2::Metadatum& value)
{
  double decimal = 0 ;
  double denom   = 1 ;

  for ( int i = 0 ; i < value.count() ; i++)
  {
    Exiv2::Rational rational = value.toRational(i);
    decimal += value.toFloat(i) / denom;
    denom   *= 60;
  }

  return decimal;
}

Exiv2::URationalValue::AutoPtr decimalToGpsRational(double coord)
{
  coord = fabs(coord);

  auto degrees = (int)coord;
  auto minutes = (int)((coord - degrees) * 60.0);
  double seconds = (coord - degrees - minutes / 60.0) * 60.0 * 60.0;

  Exiv2::URationalValue::AutoPtr rv(new Exiv2::URationalValue);
  rv->value_.push_back(std::make_pair(degrees, 1));
  rv->value_.push_back(std::make_pair(minutes, 1));
  rv->value_.push_back(Exiv2::floatToRationalCast(seconds));

  return rv;
}

double stringToDouble(Exiv2::Metadatum& value)
{
  return stod(value.toString());
}

Image::Image(const string &path)
:
path(path)
{}

void Image::load()
{
  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open(path);
  if (!image.get()) throw runtime_error(string("UNABLE TO OPEN IMAGE: ") + path);

  image->readMetadata();
  auto &exifData = image->exifData();
  auto &xmpData = image->xmpData();

  description = exifData["Exif.Image.ImageDescription"].toString();

  double lat = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLatitude"]);
  if (exifData["Exif.GPSInfo.GPSLatitudeRef"].toString() == "S") lat *= -1;

  double lon = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLongitude"]);
  if (exifData["Exif.GPSInfo.GPSLongitudeRef"].toString() == "W") lon *= -1;

  point.z = stringToDouble(xmpData["Xmp.drone-dji.RelativeAltitude"]);

  GeoConv::LLtoUTM(lat, lon, point.y, point.x, zone);

  cout << description << endl;
  cout << "LAT: " << lat << " LON: "  << lon << " ALT: " << point.z << endl;
  cout << "NORTH: " << point.y << " EAST: " << point.x << " ZONE: " << zone << endl << endl;
}

void Image::save()
{
  double lat;
  double lon;
  GeoConv::UTMtoLL(point.y, point.x, zone, lat, lon);

  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open(path);
  if (!image.get()) throw runtime_error(string("UNABLE TO OPEN IMAGE: ") + path);

  image->readMetadata();
  auto &exifData = image->exifData();
  auto &xmpData = image->xmpData();

  exifData["Exif.GPSInfo.GPSLatitude"] = *decimalToGpsRational(lat);
  exifData["Exif.GPSInfo.GPSLatitudeRef"].setValue(lat < 0 ? "S" : "N");

  exifData["Exif.GPSInfo.GPSLongitude"] = *decimalToGpsRational(lon);
  exifData["Exif.GPSInfo.GPSLongitudeRef"].setValue(lon < 0 ? "W" : "E");

  xmpData["Xmp.drone-dji.RelativeAltitude"].setValue(to_string(point.z));
  xmpData["Xmp.drone-dji.GimbalPitchDegree"].setValue("-90"); // XXX

  image->writeMetadata();

  cout << description << " " << lat << " " << lon << " " << point.z << endl;
}

void Image::transpose(const Point &refPoint)
{
  Point local;
  local.x = point.x - refPoint.x;
  local.y = point.y - refPoint.y;
  local.z = point.z - refPoint.z;

  swap(local.y, local.z);

  point.x = local.x + refPoint.x;
  point.y = local.y + refPoint.y;
  point.z = local.z + refPoint.z;
}
