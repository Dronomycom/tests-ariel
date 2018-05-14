#include "ThreadedTileLoader.h"
#include <sstream>

static const string URL_PREFIX = "https://api.mapbox.com/v4/mapbox.satellite/";
static const string ACCESS_TOKEN = "pk.eyJ1IjoiYXJpZWxtIiwiYSI6ImNqZzIxN2FseTBkMGYzM3FuNXYxOHhya2MifQ.b8YyfCV3rkFRd4C9uPSzpA";

ThreadedTileLoader::ThreadedTileLoader(){
    ofAddListener(ofEvents().update, this, &ThreadedTileLoader::update);
	ofAddListener(ofURLResponseEvent(),this,&ThreadedTileLoader::urlResponse);
    
    startThread();
}

ThreadedTileLoader::~ThreadedTileLoader(){
	pixels_to_load_from_disk.close();
	pixels_to_update.close();
	waitForThread(true);
    ofRemoveListener(ofEvents().update, this, &ThreadedTileLoader::update);
	ofRemoveListener(ofURLResponseEvent(),this,&ThreadedTileLoader::urlResponse);
}

// Load pixels from disk.
//--------------------------------------------------------------
void ThreadedTileLoader::loadFromDisk(int tx, int ty, int tz) {
	TileLoaderEntry entry;
	entry.filename = ofToDataPath("sat_" + ofToString(tz) + "-" + ofToString(tx) + "-" + ofToString(ty) + ".jpg");
	entry.name = ofToString(tx) + "|" + ofToString(ty) + "|" + ofToString(tz);
    
	pixels_to_load_from_disk.send(entry);
}


// Load an url asynchronously from an url.
//--------------------------------------------------------------
void ThreadedTileLoader::loadFromURL(int tx, int ty, int tz) {
	TileLoaderEntry entry;
    entry.url = URL_PREFIX + ofToString(tz) + "/" + ofToString(tx) + "/" + ofToString(ty) + ".jpg90?access_token=" + ACCESS_TOKEN;
	entry.name = ofToString(tx) + "|" + ofToString(ty) + "|" + ofToString(tz);
    
	images_async_loading[entry.name] = entry;
	ofLoadURLAsync(entry.url, entry.name);
}


// Reads from the queue and loads new images.
//--------------------------------------------------------------
void ThreadedTileLoader::threadedFunction() {
	thread.setName("ThreadedPixelsLoader " + thread.name());
	TileLoaderEntry entry;
	while( pixels_to_load_from_disk.receive(entry) ) {
		if(ofLoadImage(entry.pixels, entry.filename)) {
			pixels_to_update.send(entry);
		}else{
            entry.hasError = true;
            ofNotifyEvent(event, entry, this);
			ofLogError("ThreadedPixelsLoader") << "couldn't load file: \"" << entry.filename << "\"";
		}
	}
}


// When we receive an url response this method is called; 
// The loaded image is removed from the async_queue and added to the
// update queue. The update queue is used to update the texture.
//--------------------------------------------------------------
void ThreadedTileLoader::urlResponse(ofHttpResponse & response) {
	// this happens in the update thread so no need to lock to access
	// images_async_loading
	entry_iterator it = images_async_loading.find(response.request.name);
	if(response.status == 200) {
		if(it != images_async_loading.end()) {
			ofLoadImage(it->second.pixels, response.data);
			pixels_to_update.send(it->second);
		}
	}else{
        it->second.hasError = true;
        ofNotifyEvent(event, it->second, this);
		ofLogError("ThreadedPixelsLoader") << "couldn't load url, response status: " << response.status;
		ofRemoveURLRequest(response.request.getID());
	}

	// remove the entry from the queue
	if(it != images_async_loading.end()) {
		images_async_loading.erase(it);
	}
}


// Check the update queue and update the texture
//--------------------------------------------------------------
void ThreadedTileLoader::update(ofEventArgs & a){
	TileLoaderEntry entry;
	if (pixels_to_update.tryReceive(entry)) {
        ofNotifyEvent(event, entry, this);
	}
}
