#!/usr/bin/env python
# encoding: utf-8

import numpy
import matplotlib.pyplot as pplt
from scipy.spatial import Delaunay
import fileinput
import point


def showDelaunay(points):
    """ 
    Plots the Delaunay diagram of a given set of points.
    I uses the Scipy library.
    docs.scipy.org/doc/scipy-0.13.0/reference/generated/scipy.spatial.Delaunay.html

    Returns Delaunay triangulation.
    """
    array = []
    for point in points:
        array.append([point.getX(), point.getY()])
    array = numpy.array(array)

    # Compute Delaunay
    triangulation = Delaunay(array)

    # Plot Delaunay
    pplt.triplot(array[:,0], array[:,1], triangulation.simplices.copy())
    pplt.plot(array[:,0], array[:,1], 'o')
    pplt.show()

    return triangulation



import graph
import itertools
def triangulationToGraph (triangulation):
    """ Convierte una triangulación en un grafo. """

    trigraph = graph.Graph()
    points = triangulation.points.tolist()
    
    # Añade los puntos al grafo.
    for p in points:
        trigraph.addVertex(point.Point(p[0], p[1]))
        print point.Point(p[0],p[1])
    
    # Para cada punto del grafo, añade sus vecinos.
    for t in triangulation.simplices:
        da = points[t[0]]
        db = points[t[1]]
        dc = points[t[2]]

        pa = point.Point(da[0], da[1])
        pb = point.Point(db[0], db[1])
        pc = point.Point(dc[0], dc[1])

        a = trigraph.getVertex(pa)
        b = trigraph.getVertex(pb)
        c = trigraph.getVertex(pc)

        distance_ab = a.getId.euclideanDistance(b.getId)
        distance_bc = b.getId.euclideanDistance(c.getId)
        distance_ca = c.getId.euclideanDistance(a.getId)

        getVertex(a).addNeighbor(b, distance_ab)
        getvertex(b).addNeighbor(c, distance_bc)
        getvertex(c).addNeighbor(a, distance_ca)

    return trigraph



# Dibujando grafos de puntos bidimensionales.
import networkx
def draw_graph(graph):
    # Genera un grafo de Networkx
    g = networkx.Graph()

    for node in graph.getVertices():
        g.add_node(node.getId().getX(), node.getId().getY())
        for neighbor in node.getConnections():
            g.add_edge(node, neighbor)

    # Dibuja este grafo
    networkx.draw(g)
    plt.show()



if __name__ == "__main__":
    points = point.readPoints()
    triangulation = showDelaunay(points)
    graph = triangulationToGraph(triangulation)
    draw_graph(graph)
