//
//  Type3.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "TypeMission.h"

class Type3 : public TypeMission
{
public:
    double rth;
    double alt;
    
    int getId() final { return 3; }
    void encode(ofstream &stream) final;
    
    static void mix(istringstream &stream, NSMutableDictionary *data);
};
