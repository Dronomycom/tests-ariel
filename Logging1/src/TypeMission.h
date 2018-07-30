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
    int siteId;
    string siteName;
    
    int getId() override { return 0; }
    void encode(ofstream &stream) override;
    
    static void mix(istringstream &stream, NSMutableDictionary *data);
};
