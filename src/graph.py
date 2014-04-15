#encoding: utf-8

# Implementación de grafos en Python.
# Usando diccionarios como lista de adyacencia.
# Implementación tomada de: http://interactivepython.org/courselib/static/pythonds/Graphs/graphintro.html

class Vertex:
    def __init__(self,key):
        """ El vértice  """
        self.id = key
        self.connectedTo = {}

    def addNeighbor(self,nbr,weight=0):
        """ Añade una adyacencia. """
        self.connectedTo[nbr] = weight

    def __str__(self):
        return str(self.id) + ' connectedTo: ' + str([x.id for x in self.connectedTo])

    def getConnections(self):
        """ Devuelve los vértices adyacentes a él. """
        return self.connectedTo.keys()

    def getId(self):
        """ Devuelve contenido del vértice. """
        return self.id

    def getWeight(self,nbr):
        """ Devuelve peso de la arista. """
        return self.connectedTo[nbr]


class Graph:
    def __init__(self):
        """ Construye un grafo vacío. """
        self.vertList = {}
        self.numVertices = 0

    def addVertex(self,key):
        """ Añade un vértice al grafo, dado su valor. """
        self.numVertices = self.numVertices + 1
        newVertex = Vertex(key)
        self.vertList[key] = newVertex
        return newVertex

    def getVertex(self,n):
        """ Devuelve el vértice de clave dada. """
        if n in self.vertList:
            return self.vertList[n]
        else:
            return None

    def __contains__(self,n):
        """ Devuelve si n está en la lista de vértices. """ 
        return n in self.vertList

    def addEdge(self,f,t,cost=0):
        """ Añade un vértice a la lista de vértices. """
        if f not in self.vertList:
            nv = self.addVertex(f)
        if t not in self.vertList:
            nv = self.addVertex(t)
        self.vertList[f].addNeighbor(self.vertList[t], cost)

    def getVertices(self):
        """ Devuelve la lista de vértices. """
        return self.vertList.keys()

    def __iter__(self):
        """ El iterador sobre el grafo es el iterador sobre la lista de vértices. """
        return iter(self.vertList.values())
