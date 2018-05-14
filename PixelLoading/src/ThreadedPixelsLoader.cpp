#include "ThreadedPixelsLoader.h"
#include <sstream>

ThreadedPixelsLoader::ThreadedPixelsLoader(){
	nextID = 0;
    ofAddListener(ofEvents().update, this, &ThreadedPixelsLoader::update);
	ofAddListener(ofURLResponseEvent(),this,&ThreadedPixelsLoader::urlResponse);
    
    startThread();
    lastUpdate = 0;
}

ThreadedPixelsLoader::~ThreadedPixelsLoader(){
	pixels_to_load_from_disk.close();
	pixels_to_update.close();
	waitForThread(true);
    ofRemoveListener(ofEvents().update, this, &ThreadedPixelsLoader::update);
	ofRemoveListener(ofURLResponseEvent(),this,&ThreadedPixelsLoader::urlResponse);
}

// Load pixels from disk.
//--------------------------------------------------------------
void ThreadedPixelsLoader::loadFromDisk(ofPixels &pixels, string filename) {
	nextID++;
	PixelsLoaderEntry entry(pixels);
	entry.filename = filename;
	entry.name = filename;
    
	pixels_to_load_from_disk.send(entry);
}


// Load an url asynchronously from an url.
//--------------------------------------------------------------
void ThreadedPixelsLoader::loadFromURL(ofPixels &pixels, string url) {
	nextID++;
	PixelsLoaderEntry entry(pixels);
	entry.url = url;
	entry.name = "pixels" + ofToString(nextID);
	images_async_loading[entry.name] = entry;
	ofLoadURLAsync(entry.url, entry.name);
}


// Reads from the queue and loads new images.
//--------------------------------------------------------------
void ThreadedPixelsLoader::threadedFunction() {
	thread.setName("ThreadedPixelsLoader " + thread.name());
	PixelsLoaderEntry entry;
	while( pixels_to_load_from_disk.receive(entry) ) {
		if(ofLoadImage(*entry.pixels, entry.filename)) {
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
void ThreadedPixelsLoader::urlResponse(ofHttpResponse & response) {
	// this happens in the update thread so no need to lock to access
	// images_async_loading
	entry_iterator it = images_async_loading.find(response.request.name);
	if(response.status == 200) {
		if(it != images_async_loading.end()) {
			ofLoadImage(*it->second.pixels, response.data);
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
void ThreadedPixelsLoader::update(ofEventArgs & a){
	PixelsLoaderEntry entry;
	if (pixels_to_update.tryReceive(entry)) {
        ofNotifyEvent(event, entry, this);
	}
}
