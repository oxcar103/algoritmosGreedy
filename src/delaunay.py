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


import graph
import itertools
def triangulationToGraph (triangulation):
    """ Convierte una triangulación en un grafo. """

    trigraph = graph.Graph()
    points = triangulation.points.tolist()
    
    # Añade los puntos al grafo.
    for p in points:
        trigraph.addVertex(Point(p[0], p[1]))
    
    # Para cada punto del grafo, añade sus vecinos.
    for t in triangulation.simplices:
        for pair in itertools.permutations(t,2):
            a = trigraph.getVertex(pair[0])
            b = trigraph.getVertex(pair[1])
            distance = euclideanDistance(pair[0],pair[1])
            getVertex(a).addNeighbor(b, distance)

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
    showDelaunay(points)
    #graph = triangulationToGraph(Delaunay(points))
    draw_graph(graph)
