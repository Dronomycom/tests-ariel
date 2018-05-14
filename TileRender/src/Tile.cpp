//
//  Tile.cpp
//  TileRender
//
//  Created by Ariel Malka on 18/04/2018.
//

#include "Tile.h"

void Tile::uploadPixels(const ofPixels &pixels)
{
    texture.allocate(pixels);
}

void Tile::draw(float x, float y)
{
    if (texture.isAllocated())
    {
        texture.draw(x, y);
    }
}
