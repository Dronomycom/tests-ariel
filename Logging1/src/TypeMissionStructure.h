//
//  TypeMissionStructure.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "TypeMission.h"

class TypeMissionStructure : public TypeMission
{
public:
    double rth;
    double distance;
    double height;
    double min_alt;
    double approach_alt;
    double gimbal_pitch;
    double last_floor_gimbal_pitch;
    double image_overlap;
    
    void encode(ofstream &stream) final;
    
    static void mix(istringstream &stream, NSMutableDictionary *data);
};
