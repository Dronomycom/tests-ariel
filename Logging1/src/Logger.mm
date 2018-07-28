//
//  Logger.mm
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#include "Logger.h"

void Logger::begin()
{
    string logFilename = "log_" + ofGetTimestampString() + ".txt";
    logStream.open(ofxiOSGetDocumentsDirectory() + logFilename);
    
    ofstream output;
    output.open(ofxiOSGetDocumentsDirectory() + "logs.txt", ios::app);
    output << logFilename << endl;
    output.close();
}

void Logger::end()
{
    logStream.close();
}

void Logger::recordType1()
{
    logStream << 1 << '\t' << type1.product << '\t' << type1.price << endl;
}

void Logger::recordType2()
{
    logStream << 2 << '\t' << type2.age << '\t' << type2.name << '\t' << type2.surname << endl;
}
