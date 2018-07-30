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
    type1.encode(logStream);
}

void Logger::recordType2()
{
    type2.encode(logStream);
}
