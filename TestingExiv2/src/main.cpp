/*
 * Using with EXIV2_PATH=/Users/roikr/Downloads/exiv2
 * Which corresponds to the "dist" folder from http://www.exiv2.org/builds/exiv2-0.26-macosx.tar.gz
 */

#include <exiv2/exiv2.hpp>

#include <iostream>
#include <iomanip>
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

int main(int argc, char** argv)
{
  Exiv2::ExifData exifData;
  exifData["Exif.GPSInfo.GPSAltitude"] = Exiv2::Rational(253231, 1000); // RationalValue
  cout << exifData["Exif.GPSInfo.GPSAltitude"].value().toFloat() << endl;

  //

  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open("/Users/roikr/Downloads/ADJI_0014 - DJI_0021.jpg");
  assert(image.get() != 0);
  image->readMetadata();

  Exiv2::ExifData &inputData = image->exifData();
  if (inputData.empty()) {
    std::string error(argv[1]);
    error += ": No Exif data found in the file";
    throw Exiv2::Error(1, error);
  }

  /*
   * Parses "32/1 9/1 146003/2500" into 32.1662
   */
  cout << "Latitude: " << gpsRationalToDecimal(inputData["Exif.GPSInfo.GPSLatitude"]) << endl;

  /*
   * The following takes a latitude double and make a gps-rational from it
   */

  double lat = gpsRationalToDecimal(inputData["Exif.GPSInfo.GPSLatitude"]);
  auto degrees = (int)lat;
  auto minutes = (int)((lat - degrees) * 60.0);
  double seconds = (lat - degrees - minutes / 60.0) * 60.0 * 60.0;

  Exiv2::URationalValue::AutoPtr rv(new Exiv2::URationalValue);
  rv->value_.push_back(std::make_pair(degrees, 1));
  rv->value_.push_back(std::make_pair(minutes, 1));
  rv->value_.push_back(Exiv2::floatToRationalCast(seconds));

  Exiv2::ExifData outputData;
  inputData["Exif.GPSInfo.GPSLatitude"] = *rv;
  cout << inputData["Exif.GPSInfo.GPSLatitude"].value() << endl;

  return 0;
}
