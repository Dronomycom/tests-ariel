//
//  Logger.h
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#pragma once

#include "ofxiOS.h"

class Logger
{
public:
    struct Type1
    {
        string product;
        double price;
    };
    
    struct Type2
    {
        int age;
        string name;
        string surname;
    };
    
    Type1 type1;
    Type2 type2;
    
    void begin();
    void end();
    
    void recordType1();
    void recordType2();
    
protected:
    ofstream logStream;
};
