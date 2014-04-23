#!/usr/bin/env python
# encoding: utf-8

import euclidean_graph as eg
import sys

def readKPoints():
    """
    Lee puntos con el formato de entrada siguiente:
      n
      x1 x2 x3 .. xk
      y1 y2 y3 .. yk
      z1 z2 z3 .. zk
      (...)
    donde n es el número de puntos, d es la dimensión y [x1,x2,x3...xk] 
    son las coordenadas de un punto.
    """
    points = []
    n = int(input())

    for i in range(n):
        p = raw_input().strip().split()
        p = [int(x) for x in p]
        points.append(tuple(p))

    return points

if __name__ == "__main__":
    points = readKPoints()
    graph = eg.euclideanGraph(points)
    
    k = int(sys.argv[1])
    solution = eg.kruskal(graph,k)

    eg.plotGraph(solution,'k')
    eg.show()
    
