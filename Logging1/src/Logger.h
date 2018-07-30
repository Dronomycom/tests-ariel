//
//  Logger.h
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#pragma once

#include "Type1.h"
#include "Type2.h"
#include "Type3.h"

class Logger
{
public:
    Type1 type1;
    Type2 type2;
    Type3 type3;
    
    void begin();
    void end();
    
    void recordType(int typeId);
    
protected:
    ofstream logStream;
};
