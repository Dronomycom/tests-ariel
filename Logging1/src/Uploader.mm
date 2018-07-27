//
//  Uploader.mm
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#import "Uploader.h"

#include "ofxiOS.h"

@implementation Uploader

- (void)upload
{
    string path = ofxiOSGetDocumentsDirectory() + "logs.txt";
    ifstream input(path);
    
    deque<string> lines;
    string line;
    while (getline(input, line))
    {
        lines.push_back(line);
    }
    
    while (!lines.empty())
    {
        string line = lines.front();
        lines.pop_front();
        
        //
        
        cout << "TODO: process " << line << endl;
        
        //
        
        ofstream output(path);
        for (auto &line2 : lines)
        {
            output << line2 << endl;
        }
        output.close();
        
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:ofxStringToNSString(ofxiOSGetDocumentsDirectory() + line) error:&error];
    }
}

@end
