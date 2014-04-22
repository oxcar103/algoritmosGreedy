#!/usr/bin/env python
# encoding: utf-8

# Siguiendo el ejemplo de https://github.com/israelst/Algorithms-Book--Python/blob/master/5-Greedy-algorithms/kruskal.py
from sets import Set
from math import sqrt

# Formato de los grafos.
empty_graph = {
    'vertices': [],
    'edges': set()
}

def euclideanGraph(points):
    graph = {
        'vertices': [],
        'edges': set()
    }

    # Añade los nodos.
    for p in points:
        graph['vertices'].append(p)
    
    # Añade una arista de peso distancia entre cada dos puntos.
    for i in range(len(points)): 
        for j in range(i+1,len(points)):
            p,q = points[i],points[j]
            edge = (p,q,dist(p,q))
            graph['edges'].add(edge)
            
    return graph


def dist(p,q):
    """ Devuelve distancia euclídea entre dos puntos."""
    x1,y1 = p
    x2,y2 = q
    return sqrt((x1-x2)**2 + (y1-y2)**2)


# Dibujando grafos euclídeos.
from pylab import plot, show
def plotGraph(graph, clr='k'):
    # Dibuja líneas
    for edge in graph['edges']:
        p,q,weight = edge
        x1,y1 = p
        x2,y2 = q
        plot([x1,x2],[y1,y2],linestyle='-',linewidth=3, color=clr)

    # Dibuja puntos
    for point in graph['vertices']:
        x,y = point
        plot(x,y, 'ro',markersize=20)


def kruskal(graph):
    # Árbol generador minimal.
    minimum_spanning_tree = set()

    # Define una componente conexa para cada vértice.
    components = dict()
    for v in graph['vertices']:
        components[v] = Set([v])
    
    # Toma el mínimo de la lista de vértices.
    edgesList = list(graph['edges'])
    edgesList.sort(key=lambda edge:edge[2])

    # Considera cada arista del vértice.
    for edge in edgesList:
        node1, node2, weight = edge
        if components[node1] != components[node2]:
            # Realiza la unión de las componentes.
            # Los nodos del segundo componente pasan al primero.
            for node in components[node2]:
                components[node] = components[node1]
                components[node1].add(node)
            
            # Añade la arista al árbol generador.
            minimum_spanning_tree.add((node1, node2, weight))

    # Genera el grafo pedido
    mstree = {
        'vertices': graph['vertices'],
        'edges': minimum_spanning_tree
    }

    return mstree


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
        points.append((x,y))

    return points


if __name__ == "__main__":
    points = readPoints()
    graph = euclideanGraph(points)
    solution = kruskal(graph)
    
    plotGraph(graph,'k')
    plotGraph(solution,'g')
    show()
