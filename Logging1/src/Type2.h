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
    int age;
    string name;
    string surname;
    
    int getId() final { return 2; }
    void encode(ofstream &stream) final;
    
    static void process(istringstream &stream, NSMutableDictionary *data);
};
