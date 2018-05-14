#pragma once

#include "ofMain.h"
#include "ThreadedPixelsLoader.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
protected:
    ThreadedPixelsLoader pixelsLoader;
    
    void pixelsLoaderEvent(ThreadedPixelsLoader::PixelsLoaderEntry &entry);
};
