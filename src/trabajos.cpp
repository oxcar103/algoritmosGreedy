/*  Problema 4: Asignación de trabajos. Utilizando heurística greedy. 
    Se implementan 3 heurísticas greedy. 
    Buscaremos mínimos costes: pares Trabajador-Trabajo con coste mínimo, 
    con un único trabajador por trabajo y un trabajo por trabajador. 
*/

#include <iostream>
#include <vector>

using namespace std; 

vector<pair<int,int> > greedyGlobal(double **m, int size){
 
    bool trabajadores_usados[size]; 
    bool trabajos_usados[size]; 
    for (int i = 0; i < size; i++){
        trabajadores_usados[i] = false; 
        trabajos_usados[i] = false; 
    }
    vector<pair<int,int> > asignacion_final; 

    for (int i = 0; i < size; i++){	
        int minimo = 2147483647;            // 2^31 - 1, valor suficientemente grande para la comparación.   
        int pos_trabajador, pos_trabajo; 

        // Buscamos el mínimo en la matriz. Corresponderá a un trabajador y a un trabajo que aun estén libres. 
        for (int j = 0; j < size; j++){
            // Si el trabajador no está usado: 
            if (!trabajadores_usados[j])

                for (int k = 0; k < size; k++){
                    // Buscamos en los trabajos no usados. 
                    if (!trabajos_usados[k])

                        if (m[j][k] < minimo){
                            pos_trabajador = j; 
                            pos_trabajo = k; 
                            minimo = m[j][k]; 
                        }
                }
        }
        // Introducimos el par trabajador-trabajo al vector que los almacena. 
        pair<int,int> par; 
        par.first = pos_trabajador; 
        par.second = pos_trabajo; 
        asignacion_final.push_back(par); 

        trabajadores_usados[pos_trabajador] = true; 
        trabajos_usados[pos_trabajo] = true; 
    }

    return asignacion_final; 
}

vector<pair<int,int> > greedyTrabajador(double **m, int size){
    
    vector<pair<int,int> > asignacion_final; 
    bool trabajos_usados[size]; 
    for (int i = 0; i < size; i++)
        trabajos_usados[i] = false; 
    
    for (int i = 0; i < size; i++){	        // Recorremos los trabajadores. 
        int minimo = 2147483647;            // 2^31 - 1  
        int pos_trabajador, pos_trabajo; 
        // Recorriendo por trabajador, buscamos el trabajo con coste mínimo que no esté ya ocupado.
        for (int j = 0; j < size; j++){
            if (!trabajos_usados[j]) 
                if (m[i][j] < minimo){
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

vector<pair<int,int> > greedyTrabajo(double **m, int size){
    
    vector<pair<int,int> > asignacion_final; 
    bool trabajadores_usados[size]; 
    for (int i = 0; i < size; i++)
        trabajadores_usados[i] = false; 
    
    for (int i = 0; i < size; i++){	        // Recorremos los trabajos. 
        int minimo = 2147483647;            // 2^31 - 1  
        int pos_trabajador, pos_trabajo; 
        // Recorriendo por trabajo, buscamos el trabajador con coste mínimo que no esté ya ocupado.
        for (int j = 0; j < size; j++){
            if (!trabajadores_usados[j]) 
                if (m[j][i] < minimo){
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


int main(){

    int coste1 = 0, coste2 = 0, coste3 = 0;  

    int n_trabajos = 5; 
    // Creamos la matriz. 
    double **m; 
    m = new double*[n_trabajos]; 
    for (int i = 0; i < n_trabajos; i++)
        m[i] = new double[n_trabajos]; 

    // Inicializamos la matriz. 
    for (int i = 0; i < n_trabajos; i++)
       for (int j = 0; j < n_trabajos; j++)
            m[i][j] = i+j; 

    /* ---------------------- Prueba para una matriz 5x5 ------------------------------------

    m[0][0] = 9;        m[1][0] = 4;        m[2][0] = 23;       m[3][0] = 12;       m[4][0] = 9; 
    m[0][1] = 4;        m[1][1] = 15;       m[2][1] = 24;       m[3][1] = 10;       m[4][1] = 8; 
    m[0][2] = 6;        m[1][2] = 7;        m[2][2] = 72;       m[3][2] = 3;        m[4][2] = 7; 
    m[0][3] = 12;       m[1][3] = 8;        m[2][3] = 55;       m[3][3] = 9;        m[4][3] = 15; 
    m[0][4] = 7;        m[1][4] = 8;        m[2][4] = 2;        m[3][4] = 1;        m[4][4] = 4; 
    
    */

    vector<pair<int,int> > resultadoTrabajadores = greedyTrabajador(m, n_trabajos); 
    vector<pair<int,int> > resultadoTrabajos = greedyTrabajo(m, n_trabajos); 
    vector<pair<int,int> > resultadoGlobal = greedyGlobal(m, n_trabajos); 

    // Salida por pantalla de los resultados. 

    // Greedy por trabajadores
    cout << "Resultado con algoritmo greedy por trabajadores: \n"; 
    
    for (int i = 0; i < n_trabajos; i++){
        cout << "Trabajador: " << resultadoTrabajadores.at(i).first << "\tTrabajo: " << resultadoTrabajadores.at(i).second << endl; 
        coste1 += m[resultadoTrabajadores.at(i).first][resultadoTrabajadores.at(i).second]; 
    }

    cout << "Coste total: " << coste1 << endl;

    // Greedy por trabajos  
    cout << "Resultado con algoritmo greedy por trabajadores: \n"; 

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
    









            

