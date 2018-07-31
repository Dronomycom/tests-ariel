//
//  TypeMissionArea.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "TypeMissionArea.h"

void TypeMissionArea::encode(ofstream &stream)
{
    TypeMission::encode(stream);
    
    stream << '\t' << rth
           << '\t' << alt
           << '\t' << gimbal_pitch
           << '\t' << image_overlap;
}

void TypeMissionArea::mix(istringstream &stream, NSMutableDictionary *data)
{
    TypeMission::mix(stream, data);
    
    double rth;
    double alt;
    double gimbal_pitch;
    double image_overlap;

    stream >> rth
           >> alt
           >> gimbal_pitch
           >> image_overlap;
    
    data[@"rth"] = [NSNumber numberWithDouble:rth];
    data[@"alt"] = [NSNumber numberWithDouble:alt];
    data[@"gimbal_pitch"] = [NSNumber numberWithDouble:gimbal_pitch];
    data[@"image_overlap"] = [NSNumber numberWithDouble:image_overlap];
}
