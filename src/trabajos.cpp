//  Problema 4: Asignación de trabajos. Utilizando heurística greedy. Se implementan 3 heurísticas greedy. 

#include <iostream>
#include <vector>

using namespace std;

typedef vector<pair<int, int> > Asignacion;

/* 
    Heurística greedyTrabajador. Recorre la matriz por trabajador (filas) y busca el trabajo que aun no esté asignado 
    a ningún trabajado con coste mínimo, y lo asigna al trabajador actual. 
    Tiene una eficiencia cuadrática, pues consta de dos bucles for anidados.
*/
Asignacion greedyTrabajador(double **m, int size){
    
    Asignacion asignacion_final; 
    vector<bool> trabajos_usados(size, false);  
    
    for (int i = 0; i < size; i++){	        // Recorremos los trabajadores. 
        int minimo = -1;
        int pos_trabajador, pos_trabajo; 
        // Recorriendo por trabajador, buscamos el trabajo con coste mínimo que no esté ya ocupado.
        for (int j = 0; j < size; j++){
            if (!trabajos_usados[j]) 
                if (minimo < 0 || m[i][j] < minimo){
                    pos_trabajador = i;
                    pos_trabajo = j; 
                    minimo = m[i][j]; 
                }    
        }
        // Introducimos el par trabajador-trabajo al vector que los almacena. 
        pair<int,int> par; 
        par.first = pos_trabajador;  
        par.second = pos_trabajo; 
        asignacion_final.push_back(par); 

        trabajos_usados[pos_trabajo] = true; 
    }

    return asignacion_final; 
}

/* 
    Heurística greedyTrabajo. Recorre la matriz por trabajos (columnas) y busca el trabajador que aun no tenga asignado
    a ningún trabajo, y que haga mínimo el coste para ese trabajo, asignándolo al trabajo actual. 
    Es análogo al anterior, por lo que también tiene eficiencia cuadrática.  
*/
Asignacion greedyTrabajo(double **m, int size){
    
    Asignacion asignacion_final; 
    vector<bool> trabajadores_usados(size, false); 
    
    for (int i = 0; i < size; i++){	        // Recorremos los trabajos. 
        int minimo = -1;
        int pos_trabajador, pos_trabajo; 
        // Recorriendo por trabajo, buscamos el trabajador con coste mínimo que no esté ya ocupado.
        for (int j = 0; j < size; j++){
            if (!trabajadores_usados[j]) 
                if (minimo < 0 || m[j][i] < minimo){
                    pos_trabajador = j; 
                    pos_trabajo = i; 
                    minimo = m[j][i]; 
                }    
        }
        // Introducimos el par trabajador-trabajo al vector que los almacena. 
        pair<int,int> par; 
        par.first = pos_trabajador; 
        par.second = pos_trabajo; 
        asignacion_final.push_back(par); 

        trabajadores_usados[pos_trabajador] = true; 
    }

    return asignacion_final; 
}

/*
    Heurística greedyGlobal. Busca costes trabajador-trabajo mínimos en la matriz, siempre que ambos estén libres. 
    Una vez encontrados los asocia como pareja y los marca como utilizados. 
    Esta heurística tiene la desventaja de que recorre la matriz entera en cada búsqueda, por lo que es más costosa computacionalmente, 
    siendo de un orden cúbico. 
*/ 
Asignacion greedyGlobal(double **m, int size){
    vector<bool> trabajadores_usados(size, false);
    vector<bool> trabajos_usados(size, false);

    Asignacion asignacion_final; 

    for (int i = 0; i < size; i++){	
        int minimo = -1;
        int pos_trabajador, pos_trabajo; 

        // Buscamos el mínimo en la matriz. Corresponderá a un trabajador y a un trabajo que aun estén libres. 
        for (int j = 0; j < size; j++){
            // Si el trabajador no está usado: 
            if (!trabajadores_usados[j])

                for (int k = 0; k < size; k++){
                    // Buscamos en los trabajos no usados. 
                    if (!trabajos_usados[k])

                        if (minimo < 0 || m[j][k] < minimo){
                            pos_trabajador = j; 
                            pos_trabajo = k; 
                            minimo = m[j][k]; 
                        }
                }
        }
        // Introducimos el par trabajador-trabajo al vector que los almacena. 
        asignacion_final.push_back(pair<int, int>(pos_trabajador, pos_trabajo));

        trabajadores_usados[pos_trabajador] = true; 
        trabajos_usados[pos_trabajo] = true; 
    }

    return asignacion_final; 
}


int main(){

    int coste1 = 0, coste2 = 0, coste3 = 0;  

    int n_trabajos = 5; 
    // Creamos la matriz. 
    double **m; 
    m = new double*[n_trabajos]; 
    for (int i = 0; i < n_trabajos; i++)
        m[i] = new double[n_trabajos]; 

    // Inicializamos la matriz. 
    /*for (int i = 0; i < n_trabajos; i++)
       for (int j = 0; j < n_trabajos; j++)
            m[i][j] = i+j; 
*/
    //---------------------- Prueba para una matriz 5x5 ------------------------------------

    m[0][0] = 9;        m[0][1] = 4;        m[0][2] = 23;       m[0][3] = 12;       m[0][4] = 9; 
    m[1][0] = 4;        m[1][1] = 15;       m[1][2] = 24;       m[1][3] = 10;       m[1][4] = 8; 
    m[2][0] = 6;        m[2][1] = 7;        m[2][2] = 72;       m[2][3] = 3;        m[2][4] = 7; 
    m[3][0] = 12;       m[3][1] = 2;        m[3][2] = 55;       m[3][3] = 9;        m[3][4] = 15; 
    m[4][0] = 7;        m[4][1] = 8;        m[4][2] = 2;        m[4][3] = 1;        m[4][4] = 4; 
    
    

    Asignacion resultadoTrabajadores = greedyTrabajador(m, n_trabajos); 
    Asignacion resultadoTrabajos = greedyTrabajo(m, n_trabajos); 
    Asignacion resultadoGlobal = greedyGlobal(m, n_trabajos); 

    // Salida por pantalla de los resultados. 

    // Greedy por trabajadores
    cout << "Resultado con algoritmo greedy por trabajadores: \n"; 
    
    for (int i = 0; i < n_trabajos; i++){
        cout << "Trabajador: " << resultadoTrabajadores.at(i).first << "\tTrabajo: " << resultadoTrabajadores.at(i).second << endl; 
        coste1 += m[resultadoTrabajadores.at(i).first][resultadoTrabajadores.at(i).second]; 
    }

    cout << "Coste total: " << coste1 << endl;

    // Greedy por trabajos  
    cout << "Resultado con algoritmo greedy por trabajos: \n"; 

    for (int i = 0; i < n_trabajos; i++){
        cout << "Trabajador: " << resultadoTrabajos.at(i).first << "\tTrabajo: " << resultadoTrabajos.at(i).second << endl; 
        coste2 += m[resultadoTrabajos.at(i).first][resultadoTrabajos.at(i).second]; 
    }

    cout << "Coste total: " << coste2 << endl;

    // Greedy global
    cout << "Resultado con greedy global: \n"; 

    for (int i = 0; i < n_trabajos; i++){
        cout << "Trabajador: " << resultadoGlobal.at(i).first << "\tTrabajo: " << resultadoGlobal.at(i).second << endl; 
        coste3 += m[resultadoGlobal.at(i).first][resultadoGlobal.at(i).second]; 
    }
    
    cout << "Coste total: " << coste3 << endl;             

    return 0; 
}
    









            

