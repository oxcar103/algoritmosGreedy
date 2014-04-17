#!/usr/bin/env python
# encoding: utf-8

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def euclideanDistance(self,other):
        """ Distancia euclídea entre dos puntos. """
        return (self.x - other.x)**2 + (self.y - other.y)**2

    def getX(self):
        """ Devuelve la coordenada X. """
        return self.x

    def getY(self):
        """ Devuelve la coordenada Y. """
        return self.y


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

    for i in range(int(input())):
        x,y = raw_input().strip().split()
        x,y = int(x), int(y)
        points.append(Point(x,y))

    return points
