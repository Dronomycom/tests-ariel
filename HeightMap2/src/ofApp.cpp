#include "ofApp.h"

/*
 * Returns value in meters
 */
float decodeHeight(const ofPixels &pixels, int x, int y)
{
    int index = (y * pixels.getWidth() + x) * 4;
    int r = pixels[index];
    int g = pixels[index + 1];
    int b = pixels[index + 2];
    
    return ((r << 16) + (g << 8) + b) * 0.001f;
}

void ofApp::setup()
{
    string heightFilename = "ortho_height.png";
    string pictureFilename = "ortho_color.png";
    
    ofPixels heightPixels;
    ofLoadImage(heightPixels, ofToDataPath(heightFilename));
    assert(heightPixels.getBytesPerPixel() == 4);
    
    //
    
    mesh.setMode(OF_PRIMITIVE_TRIANGLES);
    mesh.disableColors();
    mesh.disableNormals();
    mesh.disableIndices();
    
    ofVec3f offset(heightPixels.getWidth() / -2.0f, heightPixels.getHeight() / -2.0f, 0);
    ofVec2f texDivider(heightPixels.getWidth(), heightPixels.getHeight());

    for (int y = 0; y < heightPixels.getHeight() - 1; y++)
    {
        for (int x = 0; x < heightPixels.getWidth() - 1; x++)
        {
            float hTL = decodeHeight(heightPixels, x, y);
            float hBL = decodeHeight(heightPixels, x, y + 1);
            float hBR = decodeHeight(heightPixels, x + 1, y + 1);
            float hTR = decodeHeight(heightPixels, x + 1, y);
            
            mesh.addVertex(offset + ofVec3f(x, y, hTL)); mesh.addTexCoord(ofVec2f(x, y) / texDivider); // TL
            mesh.addVertex(offset + ofVec3f(x, y + 1, hBL)); mesh.addTexCoord(ofVec2f(x, y + 1) / texDivider); // BL
            mesh.addVertex(offset + ofVec3f(x + 1, y + 1, hBR)); mesh.addTexCoord(ofVec2f(x + 1, y + 1) / texDivider); // BR
            
            mesh.addVertex(offset + ofVec3f(x + 1, y + 1, hBR)); mesh.addTexCoord(ofVec2f(x + 1, y + 1) / texDivider); // BR
            mesh.addVertex(offset + ofVec3f(x + 1, y, hTR)); mesh.addTexCoord(ofVec2f(x + 1, y) / texDivider); // TR
            mesh.addVertex(offset + ofVec3f(x, y, hTL)); mesh.addTexCoord(ofVec2f(x, y) / texDivider); // TL
        }
    }
    
    // ---
    
    ofPixels colorPixels;
    ofLoadImage(colorPixels, ofToDataPath(pictureFilename));
    assert(colorPixels.getWidth() == heightPixels.getWidth() && colorPixels.getHeight() == heightPixels.getHeight());
    colorTexture.allocate(colorPixels, false); // Regular (non ARB) texture
}

void ofApp::draw()
{
    ofBackground(64);
    ofEnableDepthTest();
    
    cam.begin();
    
    colorTexture.bind();
    mesh.draw();
    colorTexture.unbind();
    
    cam.end();
}

