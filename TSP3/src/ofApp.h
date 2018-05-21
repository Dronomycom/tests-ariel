#pragma once

#include "ofMain.h"

class ofApp : public ofBaseApp
{
public:
    void setup();
    void draw();
    
protected:
    vector<ofVec2f> outputPoints;
    ofVboMesh pointMesh;
};
