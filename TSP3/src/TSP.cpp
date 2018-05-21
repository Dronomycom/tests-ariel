//
//  TSP.cpp
//  TSP3
//
//  Created by Ariel Malka on 26/03/2018.
//

#include "TSP.h"

float dist(int i, int j, const vector<ofVec2f> &input)
{
    return (input[i] - input[j]).length();
}

// Function to copy temporary solution to the final solution
void TSP::copyToFinal(const vector<int> &curr_path)
{
    for (int i=0; i<N; i++)
        final_path[i] = curr_path[i];
    final_path[N] = curr_path[0];
}

// Function to find the minimum edge cost having an end at the vertex i
float TSP::firstMin(int i)
{
    float min = FLT_MAX;
    for (int k=0; k<N; k++)
        if (adj[i][k]<min && i != k)
            min = adj[i][k];
    return min;
}

// function to find the second minimum edge cost having an end at the vertex i
int TSP::secondMin(int i)
{
    float first = FLT_MAX, second = FLT_MAX;
    for (int j=0; j<N; j++)
    {
        if (i == j)
            continue;
        
        if (adj[i][j] <= first)
        {
            second = first;
            first = adj[i][j];
        }
        else if (adj[i][j] <= second &&
                 adj[i][j] != first)
            second = adj[i][j];
    }
    return second;
}

// function that takes as arguments:
// curr_bound -> lower bound of the root node
// curr_weight-> stores the weight of the path so far
// level-> current level while moving in the search space tree
// curr_path[] -> where the solution is being stored which would later be copied to final_path[]
void TSP::TSPRec(int curr_bound, float curr_weight, int level, vector<int> &curr_path)
{
    // base case is when we have reached level N which means we have covered all the nodes once
    if (level==N)
    {
        // check if there is an edge from last vertex in path back to the first vertex
        if (adj[curr_path[level-1]][curr_path[0]] != 0)
        {
            // curr_res has the total weight of the solution we got
            float curr_res = curr_weight +
            adj[curr_path[level-1]][curr_path[0]];
            
            // Update final result and final path if current result is better.
            if (curr_res < final_res)
            {
                copyToFinal(curr_path);
                final_res = curr_res;
            }
        }
        return;
    }
    
    // for any other level iterate for all vertices to build the search space tree recursively
    for (int i=0; i<N; i++)
    {
        // Consider next vertex if it is not same (diagonal entry in adjacency matrix and not visited already)
        if (adj[curr_path[level-1]][i] != 0 &&
            visited[i] == false)
        {
            int temp = curr_bound;
            curr_weight += adj[curr_path[level-1]][i];
            
            // different computation of curr_bound for level 2 from the other levels
            if (level==1)
                curr_bound -= ((firstMin(curr_path[level-1]) + firstMin(i))/2);
            else
                curr_bound -= ((secondMin(curr_path[level-1]) + firstMin(i))/2);
            
            // curr_bound + curr_weight is the actual lower bound
            // for the node that we have arrived on
            // If current lower bound < final_res, we need to explore
            // the node further
            if (curr_bound + curr_weight < final_res)
            {
                curr_path[level] = i;
                visited[i] = true;
                
                // call TSPRec for the next level
                TSPRec(curr_bound, curr_weight, level+1, curr_path);
            }
            
            // Else we have to prune the node by resetting
            // all changes to curr_weight and curr_bound
            curr_weight -= adj[curr_path[level-1]][i];
            curr_bound = temp;
            
            // Also reset the visited array
            std::fill(visited.begin(), visited.end(), 0);
            for (int j=0; j<=level-1; j++)
                visited[curr_path[j]] = true;
        }
    }
}

TSP::TSP(const vector<ofVec2f> &input)
{
    N = input.size();
    visited.resize(N);
    final_path.resize(N + 1);

    adj.resize(N);
    for (int i = 0; i < N; i++)
    {
        adj[i].resize(N);
    }
    
    for (int i = 0; i < N; i++)
    {
        for (int j = i + 1; j < N; j++)
        {
            adj[i][j] = adj[j][i] = dist(i, j, input);
        }
    }
    
    // Calculate initial lower bound for the root node using the formula 1/2 * (sum of first min + second min) for all edges.
    // Also initialize the curr_path and visited array
    
    float bound = 0;
    vector<int> curr_path(N + 1, -1);
    std::fill(visited.begin(), visited.end(), 0);
    
    // Compute initial bound
    for (int i=0; i<N; i++)
        bound += firstMin(i) + secondMin(i);
    
    // Rounding off the lower bound to an integer
    int curr_bound = int(roundf(bound / 2));
    
    // We start at vertex 1 so the first vertex in curr_path[] is 0
    visited[0] = true;
    curr_path[0] = 0;
    
    // Call to TSPRec for curr_weight equal to 0 and level 1
    TSPRec(curr_bound, 0, 1, curr_path);
}
