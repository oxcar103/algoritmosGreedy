#!/usr/bin/env python
# encoding: utf-8

import euclidean_graph as eg

def readKPoints():
    """
    Lee puntos con el formato de entrada siguiente:
      n d
      x1 x2 x3 .. xk
      y1 y2 y3 .. yk
      z1 z2 z3 .. zk
      (...)
    donde n es el número de puntos, d es la dimensión y [x1,x2,x3...xk] 
    son las coordenadas de un punto.
    """
    points = []

    for i in range(int(input())):
        p = raw_input().strip().split()
        p = [int(x) for x in p]
        points.append(p)

    return points
