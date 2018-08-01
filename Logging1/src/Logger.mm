//
//  Logger.mm
//  Logging1
//
//  Created by Ariel Malka on 26/07/2018.
//

#include "Logger.h"

void Logger::begin()
{
    t0 = ofGetElapsedTimeMillis();
    
    /*
     * Necessary in order to open logStream again
     * Alternative: doing this in Logger::end(), if such a method is defined
     */
    logStream.close();
    
    string logFilename = "log_" + ofGetTimestampString() + ".txt";
    logStream.open(ofxiOSGetDocumentsDirectory() + logFilename);
    
    ofstream output;
    output.open(ofxiOSGetDocumentsDirectory() + "logs.txt", ios::app);
    output << logFilename << endl;
    output.close();
}

void Logger::record(int messageType, int missionType)
{
    uint64_t elapsed = ofGetElapsedTimeMillis() - t0;
    
    switch (messageType)
    {
        case 1:
            type1.encode(logStream);
            break;
            
        case 2:
            type2.time = elapsed;
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
