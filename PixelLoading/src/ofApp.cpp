#include "ofApp.h"

void ofApp::setup()
{
    ofAddListener(pixelsLoader.event, this, &ofApp::pixelsLoaderEvent);
    
    pixelsLoader.loadFromURL(*(new ofPixels()), "https://api.mapbox.com/v4/mapbox.satellite/16/39128/26616.jpg90?access_token=pk.eyJ1IjoiYXJpZWxtIiwiYSI6ImNqZzIxN2FseTBkMGYzM3FuNXYxOHhya2MifQ.b8YyfCV3rkFRd4C9uPSzpA");
    
    pixelsLoader.loadFromURL(*(new ofPixels()), "https://api.mapbox.com/v4/mapbox.terrain-rgb/17/39128/26616.pngraw?access_token=pk.eyJ1IjoiYXJpZWxtIiwiYSI6ImNqZzIxN2FseTBkMGYzM3FuNXYxOHhya2MifQ.b8YyfCV3rkFRd4C9uPSzpA");
}

void ofApp::draw()
{}

void ofApp::pixelsLoaderEvent(ThreadedPixelsLoader::PixelsLoaderEntry &entry)
{
    cout << (!entry.url.empty() ? entry.url : entry.filename) << endl;
    
    if (entry.hasError || !entry.pixels)
    {
        cout << "ERROR" << endl;
    }
    else
    {
        cout << entry.pixels->getWidth() << " " << entry.pixels->getHeight() << endl;
        delete entry.pixels;
    }
    
    cout << endl;
}
