//
//  TypeMissionArea.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "TypeMission.h"

class TypeMissionArea : public TypeMission
{
public:
    double rth;
    double alt;
    double gimbal_pitch;
    double image_overlap;
    
    void encode(ofstream &stream) final;
    
    static void process(istringstream &stream, NSMutableDictionary *data);
};
