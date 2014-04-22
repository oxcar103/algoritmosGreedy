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


def kruskal(graph):
    # Árbol generador minimal.
    minimum_spanning_tree = set()

    # Define una componente conexa para cada vértice.
    components = dict()
    for v in graph['vertices']:
        components[v] = Set([v])
    
    # Toma el mínimo de la lista de vértices.
    edgesList = list(graph['edges'])
    edgesList.sort()

    # Considera cada arista del vértice.
    for edge in edgesList:
        node1, node2, weight = edge
        if component[node1] != component[node2]:
            # Realiza la unión de las componentes.
            # Los nodos del segundo componente pasan al primero.
            for node in component[node2]:
                component[node] = component[node1]
                component[node1].add(node)
            
            # Añade la arista al árbol generador.
            minimum_spanning_tree.add((node1, node2, weight))
    
    return minimum_spanning_tree
