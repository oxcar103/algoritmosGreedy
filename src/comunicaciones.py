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

    # Compute Delaunay
    triangulation = Delaunay(points)

    # Plot Delaunay
    pplt.triplot(points[:,0], points[:,1], triangulation.simplices.copy())
    pplt.plot(points[:,0], points[:,1], 'o')
    pplt.show()



if __name__ == "__main__":
    for line in fileinput.input():
        points = re.findall("\[[0-9]*,[0-9]*\]", line)
        readPoints = [[int(s) for s in point.split() if s.isdigit()] for point in points]
        print readPoints
        
