//
//  Logger.h
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#pragma once

#include "ofxiOS.h"

class Logger
{
public:
    void begin();
    void end();
    
protected:
    ofstream log;
};
