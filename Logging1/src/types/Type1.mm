//
//  Type1.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "Type1.h"

void Type1::encode(ofstream &stream)
{
    encodeHeader(stream);
    stream << '\t' << encodeString(product) << '\t' << price;
}

void Type1::process(istringstream &stream, NSMutableDictionary *data)
{
    string product;
    double price;
    stream >> product >> price;
    
    data[@"product"] = ofxStringToNSString(decodeString(product));
    data[@"price"] = [NSNumber numberWithDouble:price];
}
