#pragma once

#include "Logger.h"

class ofApp : public ofxiOSApp
{
public:
    void setup();
    void draw();
    
protected:
    Logger logger;
};
