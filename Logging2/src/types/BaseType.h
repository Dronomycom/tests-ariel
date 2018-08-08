//
//  BaseType.h
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#pragma once

#include "ofxiOS.h"

class BaseType
{
public:
    virtual int getId() = 0;
    virtual void encode(ofstream &stream) = 0;
    void encodeHeader(ofstream &stream);
    
    static string encodeString(const string &s)
    {
        if (s.empty())
        {
            return "^";
        }
        
        string s2 = s;
        std::replace(s2.begin(), s2.end(), ' ', '|');
        return s2;
    }
    
    static string decodeString(const string &s)
    {
        if (s == "^")
        {
            return "";
        }
        
        string s2 = s;
        std::replace(s2.begin(), s2.end(), '|', ' ');
        return s2;
    }
};
