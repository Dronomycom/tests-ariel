#pragma once

#include "ofThread.h"
#include "ofImage.h"
#include "ofURLFileLoader.h"
#include "ofTypes.h" 
#include "ofThreadChannel.h"

using namespace std;

class ThreadedTileLoader : public ofThread {
public:
    ThreadedTileLoader();
    ~ThreadedTileLoader();

	void loadFromDisk(int tx, int ty, int tz);
	void loadFromURL(int tx, int ty, int tz);

    // Entry to load.
    struct TileLoaderEntry {
        ofPixels pixels;
        string filename;
        string url;
        string name;
        bool hasError = false;
    };
    
    ofEvent<TileLoaderEntry> event;

private:
	void update(ofEventArgs &a);
    virtual void threadedFunction();
	void urlResponse(ofHttpResponse &response);

    typedef map<string, TileLoaderEntry>::iterator entry_iterator;

	map<string,TileLoaderEntry> images_async_loading; // keeps track of images which are loading async
	ofThreadChannel<TileLoaderEntry> pixels_to_load_from_disk;
	ofThreadChannel<TileLoaderEntry> pixels_to_update;
};
