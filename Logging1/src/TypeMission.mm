//
//  TypeMission.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "TypeMission.h"

void TypeMission::encode(ofstream &stream)
{
    encodeHeader(stream);
    stream << '\t' << siteId << '\t' << encodeString(siteName);
}

void TypeMission::mix(istringstream &stream, NSMutableDictionary *data)
{
    int siteId;
    string siteName;
    stream >> siteId >> siteName;
    
    data[@"siteId"] = [NSNumber numberWithInt:siteId];
    data[@"siteName"] = ofxStringToNSString(decodeString(siteName));
}
