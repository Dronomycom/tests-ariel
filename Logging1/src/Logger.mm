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

void Logger::record(int messageType, int missionType)
{
    switch (messageType)
    {
        case 1:
            type1.encode(logStream);
            break;
            
        case 2:
            type2.encode(logStream);
            break;
            
        case 3:
            switch (missionType)
            {
                case 1:
                case 2:
                    typeMissionArea.missionType = missionType;
                    typeMissionArea.encode(logStream);
                    break;
                    
                case 3:
                case 4:
                    typeMissionStructure.missionType = missionType;
                    typeMissionStructure.encode(logStream);
                    break;
                    
                case 5:
                    typeMissionRecon.missionType = missionType;
                    typeMissionRecon.encode(logStream);
                    break;
            }
            break;
    }
    
    logStream << endl;
}
