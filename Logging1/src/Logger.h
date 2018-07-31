//
//  Logger.h
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#pragma once

#include "Type1.h"
#include "Type2.h"
#include "TypeMissionArea.h"

class Logger
{
public:
    Type1 type1;
    Type2 type2;
    TypeMissionArea typeMissionArea;
    
    void begin();
    void end();
    
    void record(int typeId, int missionType = 0);
    
protected:
    ofstream logStream;
};
