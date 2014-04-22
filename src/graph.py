#!/usr/bin/env python
# encoding: utf-8

# Implementación de grafos en Python.
from sets import Set

class Graph:
    def __init__(self, points):
        self.nodes = points
        self.edges = set([])
        
    
