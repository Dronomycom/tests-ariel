#pragma once

#include "ofThread.h"
#include "ofImage.h"
#include "ofURLFileLoader.h"
#include "ofTypes.h" 
#include "ofThreadChannel.h"

using namespace std;

class ThreadedPixelsLoader : public ofThread {
public:
    ThreadedPixelsLoader();
    ~ThreadedPixelsLoader();

	void loadFromDisk(ofPixels &pixels, string file);
	void loadFromURL(ofPixels &pixels, string url);

    // Entry to load.
    struct PixelsLoaderEntry {
        PixelsLoaderEntry() = default;
        
        PixelsLoaderEntry(ofPixels &pPixels) {
            pixels = &pPixels;
        }
        ofPixels *pixels = nullptr;
        string filename;
        string url;
        string name;
        bool hasError = false;
    };
    
    ofEvent<PixelsLoaderEntry> event;

private:
	void update(ofEventArgs & a);
    virtual void threadedFunction();
	void urlResponse(ofHttpResponse & response);

    typedef map<string, PixelsLoaderEntry>::iterator entry_iterator;

	int nextID;
    int lastUpdate;

	map<string,PixelsLoaderEntry> images_async_loading; // keeps track of images which are loading async
	ofThreadChannel<PixelsLoaderEntry> pixels_to_load_from_disk;
	ofThreadChannel<PixelsLoaderEntry> pixels_to_update;
};
