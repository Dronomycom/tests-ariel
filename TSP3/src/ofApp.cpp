/*
 * Based on https://www.geeksforgeeks.org/branch-bound-set-5-traveling-salesman-problem/
 */

#include "ofApp.h"
#include "TSP.h"

void ofApp::setup()
{
    vector<ofVec2f> inputPoints;

    inputPoints.emplace_back(100, 200);
    inputPoints.emplace_back(350, 600);
    inputPoints.emplace_back(240, 70);
    inputPoints.emplace_back(810, 330);
    inputPoints.emplace_back(560, 710);
    inputPoints.emplace_back(500, 400);
    
//    inputPoints.emplace_back(14.0037832, -32.8761902);
//    inputPoints.emplace_back(20.5812073, 14.7250366);
//    inputPoints.emplace_back(-15.0036316, -1.28389931);
//    inputPoints.emplace_back(34.0271759, -21.077549);

    TSP tsp(inputPoints);
    
    cout << tsp.final_res << endl;

    for (int i=0; i < tsp.final_path.size(); i++)
    {
        cout << tsp.final_path[i] << " ";
        outputPoints.push_back(inputPoints[tsp.final_path[i]]);
    }
    
    //
    
    pointMesh.setMode(OF_PRIMITIVE_POINTS);
    pointMesh.disableColors();
    pointMesh.disableIndices();
    pointMesh.disableNormals();
    pointMesh.disableTextures();
    
    for (const auto &point : inputPoints)
    {
        pointMesh.addVertex(point);
    }
}

void ofApp::draw()
{
    ofClear(255, 255, 255);
    
    ofNoFill();
//    ofTranslate(ofGetWidth() * 0.5f, ofGetHeight() * 0.5f);
    
    ofSetColor(ofColor::black);
    ofBeginShape();
    for (const auto &point : outputPoints)
    {
        ofVertex(point.x, point.y);
    }
    ofEndShape(false);
    
    glPointSize(6);
    ofSetColor(ofColor::red);
    pointMesh.drawVertices();
}
