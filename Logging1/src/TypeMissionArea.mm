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
    stream << '\t' << rth << '\t' << alt;
}

void TypeMissionArea::mix(istringstream &stream, NSMutableDictionary *data)
{
    TypeMission::mix(stream, data);
    
    double rth;
    double alt;
    stream >> rth >> alt;
    
    data[@"rth"] = [NSNumber numberWithDouble:rth];
    data[@"alt"] = [NSNumber numberWithDouble:alt];
}
