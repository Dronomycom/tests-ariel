//
//  Type1.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "BaseType.h"

class Type1 : public BaseType
{
public:
    string product;
    double price;
    
    int getId() final { return 1; }
    void encode(ofstream &stream) final;
};
