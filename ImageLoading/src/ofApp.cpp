#include "ofApp.h"

void ofApp::setup()
{
    ofAddListener(imageLoader.imageEvent, this, &ofApp::imageEvent);
    
    imageLoader.loadFromURL(*(new ofImage()), "https://api.mapbox.com/v4/mapbox.satellite/16/39128/26616.jpg90?access_token=pk.eyJ1IjoiYXJpZWxtIiwiYSI6ImNqZzIxN2FseTBkMGYzM3FuNXYxOHhya2MifQ.b8YyfCV3rkFRd4C9uPSzpA");
    
    imageLoader.loadFromURL(*(new ofImage()), "https://api.mapbox.com/v4/mapbox.terrain-rgb/17/39128/26616.pngraw?access_token=pk.eyJ1IjoiYXJpZWxtIiwiYSI6ImNqZzIxN2FseTBkMGYzM3FuNXYxOHhya2MifQ.b8YyfCV3rkFRd4C9uPSzpA");
}

void ofApp::draw()
{}

void ofApp::imageEvent(ThreadedImageLoader::ofImageLoaderEntry &entry)
{
    cout << (!entry.url.empty() ? entry.url : entry.filename) << endl;
    
    if (entry.hasError || !entry.image)
    {
        cout << "ERROR" << endl;
    }
    else
    {
        cout << entry.image->getWidth() << " " << entry.image->getHeight() << endl;
        delete entry.image;
    }
    
    cout << endl;
}
