/*
 * Using with EXIV2_PATH=/Users/roikr/Downloads/exiv2
 * Which corresponds to the "dist" folder from http://www.exiv2.org/builds/exiv2-0.26-macosx.tar.gz
 */

#include "Image.h"

#include <iostream>

#include <boost/filesystem.hpp>
#include <boost/range/iterator_range.hpp>

namespace fs = boost::filesystem;
using namespace std;

const string SOURCE_FOLDER = "/Users/roikr/Desktop/transpose/input";

int main(int argc, char** argv)
{
  vector<Image> images;

  for(auto &entry : boost::make_iterator_range(fs::directory_iterator(SOURCE_FOLDER), {}))
  {
    if (fs::is_regular_file(entry))
    {
      images.emplace_back(entry.path().string());
    }
  }

  for (auto &image : images)
  {
    image.load();
  }

  Image::Point &refPoint = images.front().point;

  for (auto &image : images)
  {
    image.transpose(refPoint);
  }

  for (auto &image : images)
  {
    image.save();
  }

  return 0;
}
