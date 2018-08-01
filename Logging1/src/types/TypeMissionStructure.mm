//
//  TypeMissionStructure.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "TypeMissionStructure.h"

void TypeMissionStructure::encode(ofstream &stream)
{
    TypeMission::encode(stream);
    
    stream << '\t' << rth
           << '\t' << distance
           << '\t' << height
           << '\t' << min_alt
           << '\t' << approach_alt
           << '\t' << gimbal_pitch
           << '\t' << last_floor_gimbal_pitch
           << '\t' << image_overlap;
}

void TypeMissionStructure::process(istringstream &stream, NSMutableDictionary *data)
{
    TypeMission::process(stream, data);
    
    double rth;
    double distance;
    double height;
    double min_alt;
    double approach_alt;
    double gimbal_pitch;
    double last_floor_gimbal_pitch;
    double image_overlap;
    
    stream >> rth
           >> distance
           >> height
           >> min_alt
           >> approach_alt
           >> gimbal_pitch
           >> last_floor_gimbal_pitch
           >> image_overlap;
    
    data[@"rth"] = [NSNumber numberWithDouble:rth];
    data[@"distance"] = [NSNumber numberWithDouble:distance];
    data[@"height"] = [NSNumber numberWithDouble:height];
    data[@"min_alt"] = [NSNumber numberWithDouble:min_alt];
    data[@"approach_alt"] = [NSNumber numberWithDouble:approach_alt];
    data[@"gimbal_pitch"] = [NSNumber numberWithDouble:gimbal_pitch];
    data[@"last_floor_gimbal_pitch"] = [NSNumber numberWithDouble:last_floor_gimbal_pitch];
    data[@"image_overlap"] = [NSNumber numberWithDouble:image_overlap];
}
