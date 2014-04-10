import numpy
import matplotlib.pyplot as pplt
from scipy.spatial import Delaunay
import fileinput


def showDelaunay(points):
    """ 
    Plots the Delaunay diagram of a given set of points.
    I uses the Scipy library.
    docs.scipy.org/doc/scipy-0.13.0/reference/generated/scipy.spatial.Delaunay.html
    """

    # Compute Delaunay
    triangulation = Delaunay(points)

    # Plots Delaunay
    pplt.triplot(points[:,0], points[:,1], triangulation.simplices.copy())
    pplt.plot(points[:,0], points[:,1], 'o')
    pplt.show()



if __name__ == "__main__":
    pass

