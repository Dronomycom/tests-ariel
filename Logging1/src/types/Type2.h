//
//  Type2.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "BaseType.h"

class Type2 : public BaseType
{
public:
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
    
    int getId() final { return 2; }
    void encode(ofstream &stream) final;
    
    static void process(istringstream &stream, NSMutableDictionary *data);
};
