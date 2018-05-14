#include "ofApp.h"

/*
 * https://blog.mapbox.com/global-elevation-data-6689f1d0ba65
 */
float decodeHeight(const ofPixels &pixels, int x, int y)
{
    int index = (y * pixels.getWidth() + x) * 4;
    int r = pixels[index];
    int g = pixels[index + 1];
    int b = pixels[index + 2];
    
    return -10000 + (r * 256 * 256 + g * 256 + b) * 0.1f;
}

void ofApp::setup()
{
    /*
     * Mt. St. Helens, Usa
     */
//    float latitude = 46.1988f;
//    float zoomLevel = 12;
//    string heightFilename = "height_12-657-1453.png";
//    string satFilename = "sat_12-657-1453.jpg";
    
    /*
     * Lokvollen, Norway
     */
    float latitude = 69.4934f;
    float zoomLevel = 11;
    string heightFilename = "height_11-1141-466.png";
    string satFilename = "sat_11-1141-466.jpg";

    /*
     * Paris, France
     */
//    float latitude = 48.8896f;
//    float zoomLevel = 15;
//    string heightFilename = "height_15-16597-11268.png";
//    string satFilename = "sat_15-16597-11268.jpg";
    
    /*
     * Judean desert, Israel
     */
//    float latitude = 31.8443f;
//    float zoomLevel = 12;
//    string heightFilename = "height_12-2449-1665.png";
//    string satFilename = "sat_12-2449-1665.jpg";
    
    /*
     * https://wiki.openstreetmap.org/wiki/Zoom_levels
     */
    float resolution = (6372798.2 * M_PI * 2) * cosf(ofDegToRad(latitude)) / powf(2, zoomLevel + 8); // How many meters is a pixel
    float heightDivider = fabsf(resolution); // XXX

    ofPixels heightPixels;
    ofLoadImage(heightPixels, ofToDataPath(heightFilename));
    assert(heightPixels.getBytesPerPixel() == 4);

    //
    
    mesh.setMode(OF_PRIMITIVE_TRIANGLES);
    mesh.disableColors();
    mesh.disableNormals();
    mesh.disableIndices();
    
    ofVec3f offset(-128, -128, 0);
    
    for (int y = 0; y < 256 - 1; y++)
    {
        for (int x = 0; x < 256 - 1; x++)
        {
            float hTL = decodeHeight(heightPixels, x, y) / heightDivider;
            float hBL = decodeHeight(heightPixels, x, y + 1) / heightDivider;
            float hBR = decodeHeight(heightPixels, x + 1, y + 1) / heightDivider;
            float hTR = decodeHeight(heightPixels, x + 1, y) / heightDivider;

            mesh.addVertex(offset + ofVec3f(x, y, hTL)); mesh.addTexCoord(ofVec2f(x, y) / 256); // TL
            mesh.addVertex(offset + ofVec3f(x, y + 1, hBL)); mesh.addTexCoord(ofVec2f(x, y + 1) / 256); // BL
            mesh.addVertex(offset + ofVec3f(x + 1, y + 1, hBR)); mesh.addTexCoord(ofVec2f(x + 1, y + 1) / 256); // BR
            
            mesh.addVertex(offset + ofVec3f(x + 1, y + 1, hBR)); mesh.addTexCoord(ofVec2f(x + 1, y + 1) / 256); // BR
            mesh.addVertex(offset + ofVec3f(x + 1, y, hTR)); mesh.addTexCoord(ofVec2f(x + 1, y) / 256); // TR
            mesh.addVertex(offset + ofVec3f(x, y, hTL)); mesh.addTexCoord(ofVec2f(x, y) / 256); // TL
        }
    }
    
    // ---
    
    ofPixels satPixels;
    ofLoadImage(satPixels, ofToDataPath(satFilename));
    satTexture.allocate(satPixels, false); // Square texture
}

void ofApp::draw()
{
    ofBackground(64);
    ofEnableDepthTest();
    
    cam.begin();
    
    satTexture.bind();
    mesh.draw();
    satTexture.unbind();
    
    cam.end();
}
