/*
 * Using with EXIV2_PATH=/Users/roikr/Downloads/exiv2
 * Which corresponds to the "dist" folder from http://www.exiv2.org/builds/exiv2-0.26-macosx.tar.gz
 */

#include <exiv2/exiv2.hpp>

#include <iostream>
#include <iomanip>
#include <cassert>

using namespace std;

int main(int argc, char** argv)
{
//  Exiv2::ExifData exifData;
//  exifData["Exif.Image.XResolution"] = Exiv2::FloatValue(123.456f); // FloatValue
//  exifData["Exif.Image.YResolution"] = Exiv2::Rational(-2, 3); // RationalValue
//  exifData["Exif.GPSInfo.GPSLatitude"] = Exiv2::FloatValue(32.1662).toRational(); // Exiv2::floatToRationalCast(32.1662)
//
//  cout << exifData["Exif.Image.XResolution"].value().toFloat() << endl;
//  cout << exifData["Exif.Image.YResolution"].value().toFloat() << endl;
//  cout << exifData["Exif.GPSInfo.GPSLatitude"].value() << endl;


  Exiv2::URationalValue::AutoPtr rv(new Exiv2::URationalValue);
  rv->read("32/1 9/1 146003/2500");
  cout << (*rv).toFloat() << endl;


//  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open("/Users/roikr/Downloads/ADJI_0014 - DJI_0021.jpg");
//  assert(image.get() != 0);
//  image->readMetadata();
//
//  Exiv2::ExifData &exifData = image->exifData();
//  if (exifData.empty()) {
//    std::string error(argv[1]);
//    error += ": No Exif data found in the file";
//    throw Exiv2::Error(1, error);
//  }
//
//  /*
//   * Problem: it reads "32" instead of ~32.1662 (input is "32/1 9/1 146003/2500")
//   */
//  cout << "Latitude: " << exifData["Exif.GPSInfo.GPSLatitude"].value().toFloat() << endl;

  return 0;
}
