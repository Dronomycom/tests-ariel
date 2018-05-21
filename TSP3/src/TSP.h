/*
 * Based on https://www.geeksforgeeks.org/branch-bound-set-5-traveling-salesman-problem/
 */

//
//  TSP.h
//  TSP3
//
//  Created by Ariel Malka on 26/03/2018.
//

#pragma once

#include "ofMain.h"

class TSP
{
public:
    // final_path[] stores the final solution ie, the path of the salesman.
    vector<int> final_path;
    
    // Stores the final minimum weight of shortest tour.
    float final_res = FLT_MAX;

    TSP(const vector<ofVec2f> &input);
    
private:
    int N;
    
    vector<vector<float>> adj;
    
    // visited[] keeps track of the already visited nodes in a particular path
    vector<bool> visited;
    
    void copyToFinal(const vector<int> &curr_path);
    float firstMin(int i);
    int secondMin(int i);
    void TSPRec(int curr_bound, float curr_weight, int level, vector<int> &curr_path);
};
