#!/usr/bin/env ruby
# encoding: utf-8

class Object
    # Copia profunda de objetos
    # http://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
    def deep_clone
        return @deep_cloning_obj if @deep_cloning
        @deep_cloning_obj = clone
        @deep_cloning_obj.instance_variables.each { |var|
            val = @deep_cloning_obj.instance_variable_get(var)
            begin
                @deep_cloning = true
                val = val.deep_clone
            rescue TypeError
                next
            ensure
                @deep_cloning = false
            end
            @deep_cloning_obj.instance_variable_set(var, val)
        }
        deep_cloning_obj = @deep_cloning_obj
        @deep_cloning_obj = nil
        deep_cloning_obj
    end
end


module QAP
    class Instancia
        def initialize(filename)
            # Lectura del archivo del problema QAP.
            @size = -1
            distancedata = []
            weightdata = false

            File.foreach(filename) { |l|
                if @size < 0
                    @size = l.to_i 
                elsif l =~ /^\s*$/ && distancedata.any? && !weightdata  # Línea separando distancias y pesos
                    weightdata = []
                elsif !weightdata  # Añadiendo distancias
                    distancedata += l.split(" ").map(&:to_i)
                else  # Añadiendo pesos
                    weightdata += l.split(" ").map(&:to_i)
                end
            }

            @permutation = (0..(@size-1)).to_a  # Genera un array con valores de 0 a size-1
            @distances = distancedata.each_slice(@size).to_a  # Matriz de distancias
            @weights = weightdata.each_slice(@size).to_a  # Matriz de pesos
        end

        # Acceso público a la permutación.
        attr_accessor :permutation 
        attr_reader   :size

        # Lectura de distancias y pesos.
        def distance(i,j)
            @distances[i][j]
        end
        def weight(i,j)
            @weights[i][j]
        end

        # Coste actual.
        def cost
            total_cost = 0
            @distances.each_index { |i|
                @distances[i].each_index { |j|
                    total_cost += weight(i,j)*distance(permutation[i], permutation[j])
                }
            }
            return total_cost
        end
        
        def to_s
            "Permutación: " + permutation.to_s + "\nCoste: #{cost}\n"
        end
    end

    ##
    # Heurísticas
    ##
    class Heuristicas
        # Heurística 2-opt.
        def self.opt2(qap)
            continue = true
            
            while continue
                continue = false
                
                # Realiza una permutación simple y comprueba si mejora el coste total.
                # Termina el proceso cuando no encuentra mejoras en una iteración.
                (0..(qap.size-1)).each { |i|
                    ((i+1)..(qap.size-1)).each { |j|
                        old_cost = qap.cost
                        qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i] 
                        
                        if old_cost <= qap.cost
                            # Deshacemos el cambio
                            qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i]
                        else    
                            continue = true
                        end
                    }
                }
            end
        end
        
        # Heurística Greedy basada en Vecino más cercano
        def self.greedy_v1(qap)
            min = qap.cost
            result = qap
            s = qap.size-1

            (0..s).each { |k|
                fab_asignada = Array.new(s+1){false}
                loc_asignada = Array.new(s+1){false}
                actual = qap.deep_clone
                
                (1..s).inject(k) { |i|
                    fab_asignada[i] = true
                    loc_asignada[actual.permutation[i]] = true
                    
                    # Busca el índice de la fábrica no asignada con más flujo a la k-ésima
                    max_w_index = (0..s).each_with_index.select { |j| 
                        !fab_asignada[j[0]]
                    }.collect { |j|
                        [actual.weight(k,j[0]),j[-1]]
                    }.max[-1]
                    
                    # Busca la posición más cercana a la fábrica k-ésima aún no asignada
                    min_d_index = (0..s).each_with_index.select { |j| 
                        !loc_asignada[j[0]]
                    }.collect { |j| 
                        [actual.distance(actual.permutation[k],j[0]),j[-1]]
                    }.min[-1]
 
                    # Coloca la fábrica en dicha posición
                    actual.permutation[max_w_index] = min_d_index
                    # En la próxima iteración, fábrica y localización se marcarán como asignadas
                    max_w_index
                }
                
                if actual.cost < min
                    min = actual.cost
                    result = actual
                end
            }
            qap.permutation = result.permutation
        end
        
        def self.greedy_v2(qap)
            s = qap.size-1
            fab_asignada = Array.new(s+1){false}
            loc_asignada = Array.new(s+1){false}
            w = Array.new(s+1)
            d = Array.new(s+1)
            
            # Calculamos vectores sumas de pesos y sumas de distancias
            (0..s).each { |i| 
                w[i] = (0..s).collect { |j|
                    qap.weight(i,j)
                }.inject(0) { |sum,x| 
                    sum + x
                }
                
                d[i] = (0..s).collect { |j|
                    qap.distance(i,j)
                }.inject(0) { |sum,x| 
                    sum + x
                }
            }
            
            (s+1).times {
                max_w_index = (0..s).each_with_index.select { |j|
                    !fab_asignada[j[0]]
                }.collect { |j| 
                    [w[j[0]],j[-1]]
                }.max[-1]
                
                min_d_index = (0..s).each_with_index.select { |j|
                    !loc_asignada[j[0]]
                }.collect { |j| 
                    [d[j[0]],j[-1]]
                }.min[-1]
                
                qap.permutation[max_w_index] = min_d_index
                fab_asignada[max_w_index] = true
                loc_asignada[min_d_index] = true
            }
        end
    end

    if __FILE__ == $0
        puts "Introduce nombre de archivo: "
        #file = gets.chomp
        #problema = Instancia.new(file)
        problema = Instancia.new("datos.qap/bur26a.dat")
        puts "\nPermutación inicial: \n#{problema}\n"
        
        res = problema.deep_clone
        Heuristicas.greedy_v1 res
        puts "Instancia tras greedy: \n#{res}\n"
        
        res = problema.deep_clone
        Heuristicas.greedy_v2 res
        puts "Instancia tras greedy 2: \n#{res}\n"

        res = problema.deep_clone
        Heuristicas.opt2 res
        puts "Instancia tras 2-opt: \n#{res}\n"
    end
end
