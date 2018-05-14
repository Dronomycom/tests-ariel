#include "ofApp.h"

void ofApp::setup()
{
    ofAddListener(tileLoader.event, this, &ofApp::tileLoaderEvent);
    
    if (true)
    {
        tileLoader.loadFromURL(19303, 24622, 16); // Central Park
    }
    else
    {
        tileLoader.loadFromDisk(39128, 26616, 16); // Shoham
    }
}

void ofApp::draw()
{
    ofBackground(64);
    tile.draw(ofGetWidth() * 0.5f - 128, ofGetHeight() * 0.5f - 128);
}

void ofApp::tileLoaderEvent(ThreadedTileLoader::TileLoaderEntry &entry)
{
    cout << entry.name << endl;
    
    if (entry.hasError)
    {
        cout << "ERROR" << endl;
    }
    else
    {
        tile.uploadPixels(entry.pixels);
        entry.pixels.clear();
    }
    
    cout << endl;
}
