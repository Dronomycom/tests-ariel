#include "Image.h"
#include "GeoConv.h"

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
  if (!image.get()) throw runtime_error(string("UNABLE TO LOAD IMAGE: ") + path);

  image->readMetadata();
  auto &exifData = image->exifData();
  auto &xmpData = image->xmpData();

  lat = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLatitude"]);
  if (exifData["Exif.GPSInfo.GPSLatitudeRef"].toString() == "S") lat *= -1;

  lon = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLongitude"]);
  if (exifData["Exif.GPSInfo.GPSLongitudeRef"].toString() == "W") lon *= -1;

  alt = stringToDouble(xmpData["Xmp.drone-dji.RelativeAltitude"]);

  double north;
  double east;
  string zone;
  GeoConv::LLtoUTM(lat, lon, north, east, zone);

  cout << "LAT: " << lat << " LON: "  << lon << " ALT: " << alt << endl;
  cout << "NORTH: " << north << " EAST: " << east << " ZONE: " << zone << endl << endl;
}
