#pragma once

#include "ofMain.h"

#include "ThreadedTileLoader.h"
#include "Tile.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
protected:
    ThreadedTileLoader tileLoader;
    Tile tile;
    
    void tileLoaderEvent(ThreadedTileLoader::TileLoaderEntry &entry);
};
