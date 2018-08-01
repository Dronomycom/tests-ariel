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
    
    stream << '\t' << missionType
           << '\t' << encodeString(username)
           << '\t' << siteId
           << '\t' << encodeString(siteName)
           << '\t' << locationId
           << '\t' << encodeString(locationName);
}

void TypeMission::process(istringstream &stream, NSMutableDictionary *data)
{
    string username;
    int siteId;
    string siteName;
    int locationId;
    string locationName;
    
    stream >> username
           >> siteId
           >> siteName
           >> locationId
           >> locationName;
    
    data[@"username"] = ofxStringToNSString(decodeString(username));
    data[@"siteId"] = [NSNumber numberWithInt:siteId];
    data[@"siteName"] = ofxStringToNSString(decodeString(siteName));
    data[@"locationId"] = [NSNumber numberWithInt:locationId];
    data[@"locationName"] = ofxStringToNSString(decodeString(locationName));
}

