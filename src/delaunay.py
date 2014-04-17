#!/usr/bin/env python
# encoding: utf-8

import numpy
import matplotlib.pyplot as pplt
from scipy.spatial import Delaunay
import fileinput
import re


def showDelaunay(points):
    """ 
    Plots the Delaunay diagram of a given set of points.
    I uses the Scipy library.
    docs.scipy.org/doc/scipy-0.13.0/reference/generated/scipy.spatial.Delaunay.html
    """
    points = numpy.array(points)

    # Compute Delaunay
    triangulation = Delaunay(points)

    # Plot Delaunay
    pplt.triplot(points[:,0], points[:,1], triangulation.simplices.copy())
    pplt.plot(points[:,0], points[:,1], 'o')
    pplt.show()

def readPoints():
    """
    Lee puntos con el formato de entrada siguiente:
      n
      x y
      x y
      x y
      (...)
    donde n es el número de puntos y [x,y] son las coordenadas de un punto.
    """

    points = []
    n = input()
    for x in range(n):
        a,b = raw_input().strip().split()
        a,b = int(a), int(b)
        points.append([a,b])
    return points


def euclideanDistance(a,b):
    """ Distancia euclídea entre dos puntos. """
    return (a[0]-b[0])**2 + (a[1]-b[1])**2


import graph
import itertools
def triangulationToGraph (triangulation):
    """ Convierte una triangulación en un grafo. """

    trigraph = graph.Graph()
    points = triangulation.points.tolist()
    
    # Añade los puntos al grafo.
    for p in points:
        trigraph.addVertex(p)
    
    # Para cada punto del grafo, añade sus vecinos.
    for t in triangulation.simplices:
        for pair in itertools.permutations(t,2):
            a = trigraph.getVertex(pair[0])
            b = trigraph.getVertex(pair[1])
            distance = euclideanDistance(pair[0],pair[1])
            getVertex(a).addNeighbor(b, distance)

    return trigraph

if __name__ == "__main__":
    points = readPoints()
    showDelaunay(points)
