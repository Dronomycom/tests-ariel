//
//  Uploader.mm
//  Logging1
//
//  Created by Ariel Malka on 28/07/2018.
//

#import "Uploader.h"

#include "Type1.h"
#include "Type2.h"

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
        
        cout << "PROCESSING " << line << endl;
        
        NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
        object[@"version"] = @"1.0";
        object[@"messages"] = [[NSMutableArray alloc] init];
        
        ifstream input2(ofxiOSGetDocumentsDirectory() + line);
        
        string line2;
        while (getline(input2, line2))
        {
            istringstream iss(line2);
            int type;
            double date;
            iss >> type >> date;
            
            NSMutableDictionary *message = [[NSMutableDictionary alloc] init];
            message[@"type"] = [NSNumber numberWithInt:type];
            message[@"date"] = [NSNumber numberWithDouble:date];
            message[@"data"] = [[NSMutableDictionary alloc] init];
            
            switch (type)
            {
                case 1:
                    Type1::mix(iss, message[@"data"]);
                    break;

                case 2:
                    Type2::mix(iss, message[@"data"]);
                    break;
            }
            
            [object[@"messages"] addObject:message];
            
            if ([object[@"messages"] count] == 2)
            {
                [self flush:object];
                [object[@"messages"] removeAllObjects];
            }
        }
        
        if ([object[@"messages"] count] > 0)
        {
            [self flush:object];
        }
        
        //
        
        ofstream output(path);
        for (auto &line3 : lines)
        {
            output << line3 << endl;
        }
        output.close();

        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:ofxStringToNSString(ofxiOSGetDocumentsDirectory() + line) error:&error];
    }
}

- (void)flush:(NSDictionary*)object
{
    NSLog(@"*** FLUSHING: %@ ***", object);
}

@end
