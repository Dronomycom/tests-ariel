//
//  BaseType.mm
//  Logging1
//
//  Created by Ariel Malka on 30/07/2018.
//

#include "BaseType.h"

void BaseType::encodeHeader(ofstream &stream)
{
    stream << getId();
}
