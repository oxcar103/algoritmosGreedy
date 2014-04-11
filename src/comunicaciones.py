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


if __name__ == "__main__":
    points = readPoints()
    showDelaunay(points)
