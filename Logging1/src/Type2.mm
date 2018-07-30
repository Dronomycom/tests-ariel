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
    stream << age << '\t' << encodeString(name) << '\t' << encodeString(surname) << endl;
}

void Type2::mix(istringstream &stream, NSMutableDictionary *data)
{
    int age;
    string name;
    string surname;
    stream >> age >> name >> surname;
    
    data[@"age"] = [NSNumber numberWithInt:age];
    data[@"name"] = ofxStringToNSString(decodeString(name));
    data[@"surname"] = ofxStringToNSString(decodeString(surname));
}
