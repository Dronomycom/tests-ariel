//
//  Type2.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "Type2.h"

void Type2::encode(ofstream &stream)
{
    encodeHeader(stream);
    
    stream << '\t' << latitude
           << '\t' << longitude
           << '\t' << time
           << '\t' << altitude
           << '\t' << satellites
           << '\t' << pitch
           << '\t' << roll
           << '\t' << yaw
           << '\t' << velocityX
           << '\t' << velocityY
           << '\t' << velocityZ
           << '\t' << remainPowerPercent
           << '\t' << currentCurrent
           << '\t' << currentVoltage
           << '\t' << batteryTemperature
           << '\t' << isTakingPhoto
           << '\t' << gimbalPitch
           << '\t' << gimbalRoll
           << '\t' << gimbalYaw
           << '\t' << encodeString(appTip)
           << '\t' << encodeString(appWarning);
}

void Type2::process(istringstream &stream, NSMutableDictionary *data)
{
    double latitude;
    double longitude;
    double time;
    double altitude;
    int satellites;
    double pitch;
    double roll;
    double yaw;
    double velocityX;
    double velocityY;
    double velocityZ;
    int remainPowerPercent;
    int currentCurrent;
    int currentVoltage;
    int batteryTemperature;
    bool isTakingPhoto;
    double gimbalPitch;
    double gimbalRoll;
    double gimbalYaw;
    string appTip;
    string appWarning;
    
    stream >> latitude
           >> longitude
           >> time
           >> altitude
           >> satellites
           >> pitch
           >> roll
           >> yaw
           >> velocityX
           >> velocityY
           >> velocityZ
           >> remainPowerPercent
           >> currentCurrent
           >> currentVoltage
           >> batteryTemperature
           >> isTakingPhoto
           >> gimbalPitch
           >> gimbalRoll
           >> gimbalYaw
           >> appTip
           >> appWarning;
    
    data[@"latitude"] = [NSNumber numberWithDouble:latitude];
    data[@"longitude"] = [NSNumber numberWithDouble:longitude];
    data[@"time"] = [NSNumber numberWithDouble:time];
    data[@"satellites"] = [NSNumber numberWithInt:satellites];
    data[@"pitch"] = [NSNumber numberWithDouble:pitch];
    data[@"roll"] = [NSNumber numberWithDouble:roll];
    data[@"yaw"] = [NSNumber numberWithDouble:yaw];
    data[@"velocityX"] = [NSNumber numberWithDouble:velocityX];
    data[@"velocityY"] = [NSNumber numberWithDouble:velocityY];
    data[@"velocityZ"] = [NSNumber numberWithDouble:velocityZ];
    data[@"remainPowerPercent"] = [NSNumber numberWithInt:remainPowerPercent];
    data[@"currentCurrent"] = [NSNumber numberWithInt:currentCurrent];
    data[@"currentVoltage"] = [NSNumber numberWithInt:currentVoltage];
    data[@"batteryTemperature"] = [NSNumber numberWithInt:batteryTemperature];
    data[@"isTakingPhoto"] = [NSNumber numberWithBool:isTakingPhoto];
    data[@"gimbalPitch"] = [NSNumber numberWithDouble:gimbalPitch];
    data[@"gimbalRoll"] = [NSNumber numberWithDouble:gimbalRoll];
    data[@"gimbalYaw"] = [NSNumber numberWithDouble:gimbalYaw];
    data[@"appTip"] = ofxStringToNSString(decodeString(appTip));
    data[@"appWarning"] = ofxStringToNSString(decodeString(appWarning));
}
