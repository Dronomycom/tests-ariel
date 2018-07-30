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
