//
//  TypeMissionRecon.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "TypeMissionRecon.h"

void TypeMissionRecon::encode(ofstream &stream)
{
    TypeMission::encode(stream);
    
    stream << '\t' << rth
           << '\t' << alt
           << '\t' << approach_alt;
}

void TypeMissionRecon::mix(istringstream &stream, NSMutableDictionary *data)
{
    TypeMission::mix(stream, data);
    
    double rth;
    double alt;
    double approach_alt;
    
    stream >> rth
           >> alt
           >> approach_alt;
    
    data[@"rth"] = [NSNumber numberWithDouble:rth];
    data[@"alt"] = [NSNumber numberWithDouble:alt];
    data[@"approach_alt"] = [NSNumber numberWithDouble:approach_alt];
}
