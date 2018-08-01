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
#include "TypeMissionStructure.h"
#include "TypeMissionRecon.h"

class Logger
{
public:
    Type1 type1;
    Type2 type2;
    TypeMissionArea typeMissionArea;
    TypeMissionStructure typeMissionStructure;
    TypeMissionRecon typeMissionRecon;
    
    void begin();
    void end();
    
    void record(int messageType, int missionType = 0);
    
protected:
    ofstream logStream;
    uint64_t t0;
};
