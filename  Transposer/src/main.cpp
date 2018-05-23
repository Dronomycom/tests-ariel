/*
 * Using with EXIV2_PATH=/Users/roikr/Downloads/exiv2
 * Which corresponds to the "dist" folder from http://www.exiv2.org/builds/exiv2-0.26-macosx.tar.gz
 */

#include <exiv2/exiv2.hpp>

#include <iostream>
#include <iomanip>
#include <string>
#include <cassert>

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

int main(int argc, char** argv)
{
  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open("/Users/roikr/Downloads/DJI_0027.JPG");
  assert(image.get() != 0);
  image->readMetadata();

  auto &exifData = image->exifData();
  auto &xmpData = image->xmpData();

  auto lat = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLatitude"]);
  if (exifData["Exif.GPSInfo.GPSLatitudeRef"].toString() == "S") lat *= -1;

  auto lon = gpsRationalToDecimal(exifData["Exif.GPSInfo.GPSLongitude"]);
  if (exifData["Exif.GPSInfo.GPSLongitudeRef"].toString() == "W") lon *= -1;

  auto alt = stringToDouble(xmpData["Xmp.drone-dji.RelativeAltitude"]);

  cout << lat << " " << lon << " " << alt << endl;

  //

  exifData["Exif.Image.ImageDescription"].setValue("KILLROY WAS HERE!");

  image->writeMetadata();

  return 0;
}
