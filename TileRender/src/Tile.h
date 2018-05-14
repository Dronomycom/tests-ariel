//
//  Tile.hpp
//  TileRender
//
//  Created by Ariel Malka on 18/04/2018.
//

#include "ofTexture.h"

#pragma once

class Tile
{
public:
    ofTexture texture;
    
    void uploadPixels(const ofPixels &pixels);
    void draw(float x, float y);
};
