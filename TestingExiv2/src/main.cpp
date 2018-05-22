/*
 * Using with EXIV2_PATH=/Users/roikr/Downloads/exiv2
 * Which corresponds to the "dist" folder from http://www.exiv2.org/builds/exiv2-0.26-macosx.tar.gz
 */

#include <exiv2/exiv2.hpp>

#include <iostream>
#include <iomanip>
#include <cassert>

/*
 * Example 1: exifprint.cpp
 * This is a very simple program to read and print the Exif metadata of an image. Go to Example2 to see how the output looks like.
 */

int main(int argc, char** argv)
{
  Exiv2::Image::AutoPtr image = Exiv2::ImageFactory::open("/Users/roikr/Downloads/ADJI_0014 - DJI_0021.jpg");
  assert(image.get() != 0);
  image->readMetadata();

  Exiv2::ExifData &exifData = image->exifData();
  if (exifData.empty()) {
    std::string error(argv[1]);
    error += ": No Exif data found in the file";
    throw Exiv2::Error(1, error);
  }
  Exiv2::ExifData::const_iterator end = exifData.end();
  for (Exiv2::ExifData::const_iterator i = exifData.begin(); i != end; ++i) {
    const char* tn = i->typeName();
    std::cout << std::setw(44) << std::setfill(' ') << std::left
              << i->key() << " "
              << "0x" << std::setw(4) << std::setfill('0') << std::right
              << std::hex << i->tag() << " "
              << std::setw(9) << std::setfill(' ') << std::left
              << (tn ? tn : "Unknown") << " "
              << std::dec << std::setw(3)
              << std::setfill(' ') << std::right
              << i->count() << "  "
              << std::dec << i->value()
              << "\n";
  }

  return 0;
}
