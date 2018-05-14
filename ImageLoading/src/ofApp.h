#pragma once

#include "ofMain.h"
#include "ThreadedImageLoader.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
protected:
    ThreadedImageLoader imageLoader;
    
    void imageEvent(ThreadedImageLoader::ofImageLoaderEntry &entry);
};
