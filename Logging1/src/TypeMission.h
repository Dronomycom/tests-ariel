//
//  TypeMission.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "BaseType.h"

class TypeMission : public BaseType
{
public:
    int missionType;
    string username;
    int siteId;
    string siteName;
    int locationId;
    string locationName;
    
    int getId() override { return 3; }
    void encode(ofstream &stream) override;
    
    static void process(istringstream &stream, NSMutableDictionary *data);
};
