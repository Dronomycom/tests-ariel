//
//  Utils.h
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#pragma once

#include "ofxiOS.h"

static string encodeString(const string &s)
{
    string s2 = s;
    std::replace(s2.begin(), s2.end(), ' ', '|');
    return s2;
}

static string decodeString(const string &s)
{
    string s2 = s;
    std::replace(s2.begin(), s2.end(), '|', ' ');
    return s2;
}
