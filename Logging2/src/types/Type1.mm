//
//  Type1.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "Type1.h"

void Type1::encode(ofstream &stream)
{
    encodeHeader(stream);
    
    stream << '\t' << encodeString(appVersion)
           << '\t' << encodeString(planeSerialNumber)
           << '\t' << batteryFullCapacity
           << '\t' << dischargeCount
           << '\t' << batteryLife
           << '\t' << encodeString(droneType);
}

void Type1::process(istringstream &stream, NSMutableDictionary *data)
{
    string appVersion;
    string planeSerialNumber;
    int batteryFullCapacity;
    int dischargeCount;
    int batteryLife;
    string droneType;
    
    stream >> appVersion
           >> planeSerialNumber
           >> batteryFullCapacity
           >> dischargeCount
           >> batteryLife
           >> droneType;
    
    data[@"appVersion"] = ofxStringToNSString(decodeString(appVersion));
    data[@"planeSerialNumber"] = ofxStringToNSString(decodeString(planeSerialNumber));
    data[@"batteryFullCapacity"] = [NSNumber numberWithInt:batteryFullCapacity];
    data[@"dischargeCount"] = [NSNumber numberWithInt:dischargeCount];
    data[@"batteryLife"] = [NSNumber numberWithInt:batteryLife];
    data[@"droneType"] = ofxStringToNSString(decodeString(droneType));
}
