#pragma once

#include "ofThread.h"
#include "ofImage.h"
#include "ofURLFileLoader.h"
#include "ofTypes.h" 
#include "ofThreadChannel.h"

using namespace std;

class ThreadedImageLoader : public ofThread {
public:
    ThreadedImageLoader();
    ~ThreadedImageLoader();

	void loadFromDisk(ofImage& image, string file);
	void loadFromURL(ofImage& image, string url);

    // Entry to load.
    struct ofImageLoaderEntry {
        ofImageLoaderEntry() = default;
        
        ofImageLoaderEntry(ofImage & pImage) {
            image = &pImage;
        }
        ofImage* image = nullptr;
        string filename;
        string url;
        string name;
        bool hasError = false;
    };
    
    ofEvent<ofImageLoaderEntry> imageEvent;

private:
	void update(ofEventArgs & a);
    virtual void threadedFunction();
	void urlResponse(ofHttpResponse & response);

    typedef map<string, ofImageLoaderEntry>::iterator entry_iterator;

	int                 nextID;
    int                 lastUpdate;

	map<string,ofImageLoaderEntry> images_async_loading; // keeps track of images which are loading async
	ofThreadChannel<ofImageLoaderEntry> images_to_load_from_disk;
	ofThreadChannel<ofImageLoaderEntry> images_to_update;
};


