#!/usr/bin/env ruby
# encoding: utf-8

class File
    def eat_empty_lines
        while (c=getc) == "\n"
        end
        ungetc(c)
    end
end

class Object
    # http://stackoverflow.com/questions/8206523/how-to-create-a-deep-copy-of-an-object-in-ruby
    def deep_clone
        return @deep_cloning_obj if @deep_cloning
        @deep_cloning_obj = clone
        @deep_cloning_obj.instance_variables.each do |var|
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
        end
        deep_cloning_obj = @deep_cloning_obj
        @deep_cloning_obj = nil
        deep_cloning_obj
    end
end


module QAP
    class QAP
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
            @distances.each_index do |i|
                @distances[i].each_index do |j|
                    total_cost += weight(i,j)*distance(permutation[i], permutation[j])
                end
            end
            return total_cost
        end

        ##
        # Heurísticas
        ##

        # Heurística 2-opt.
        def self.opt2(qap)
            continue = true
            
            while continue
                continue = false
                
                # Realiza una permutación simple y comprueba si mejora el coste total.
                # Termina el proceso cuando no encuentra mejoras en una iteración.
                (0..(qap.size-1)).each do |i|
                    ((i+1)..(qap.size-1)).each do |j|
                        old_cost = qap.cost
                        qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i] 
                        
                        if old_cost <= qap.cost
                            qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i]
                        else    
                            continue = true
                        end
                    end
                end
            end
        end
        
        # Heurística Greedy.
        def self.greedy_v1(qap)
            min = qap.cost
            result = qap
            s = qap.size-1

            (0..s).each do |k|
                fab_asignada = Array.new(s+1){false}
                loc_asignada = Array.new(s+1){false}
                actual = qap.deep_clone
                # actual.permutation=qap.permutation.clone
                
                (1..s).inject(k) do |i|
                    fab_asignada[i] = true
                    loc_asignada[actual.permutation[i]] = true
                    
                    # Busca el índice de la fábrica no asignada con más flujo a la k-ésima
                    max_w_index = (0..s).each_with_index.select{|j| !fab_asignada[j[0]]}.collect{|j| [actual.weight(k,j[0]),j[-1]]}.max[-1]
                    # Busca la posición más cercana a la fábrica k-ésima aún no asignada
                    min_d_index = (0..s).each_with_index.select{|j| !loc_asignada[j[0]]}.collect{|j|                                    [actual.distance(actual.permutation[k],j[0]),j[-1]]}.min[-1]
 
                    # Coloca la fábrica en dicha posición
                    actual.permutation[max_w_index] = min_d_index
                    # En la próxima iteración, fábrica y localización se marcarán como asignadas
                    max_w_index
                end
                
                if actual.cost < min
                    min = actual.cost
                    result = actual
                end
            end
            qap.permutation = result.permutation
        end
        
        def self.greedy_v2(qap)
            s = qap.size-1
            fab_asignada = Array.new(s+1){false}
            loc_asignada = Array.new(s+1){false}
            w = Array.new(s+1)
            d = Array.new(s+1)
            
            # Calculamos vectores sumas de pesos y sumas de distancias
            (0..s).each{|i| 
                w[i]=(0..s).collect{|j| qap.weight(i,j)}.inject(0){|sum,x| sum + x}
                d[i]=(0..s).collect{|j| qap.distance(i,j)}.inject(0){|sum,x| sum + x}
            }
            
            (s+1).times do
                max_w_index = (0..s).each_with_index.select{|j| !fab_asignada[j[0]]}.collect{|j| [w[j[0]],j[-1]]}.max[-1]
                min_d_index = (0..s).each_with_index.select{|j| !loc_asignada[j[0]]}.collect{|j| [d[j[0]],j[-1]]}.min[-1]
                
                qap.permutation[max_w_index] = min_d_index
                fab_asignada[max_w_index] = true
                loc_asignada[min_d_index] = true
            end
        end
        
        def to_s
            "Permutación: " + permutation.to_s + "\nCoste: #{cost}\n"
        end
    end

    if __FILE__ == $0
        puts "Introduce nombre de archivo: "
        file = gets.chomp
        instancia = QAP.new(file)
        #instancia = QAP.new("../datos.qap/bur26a.dat")
        puts "\nPermutación inicial: \n#{instancia}\n"
        
        QAP.greedy_v1 instancia
        puts "Instancia tras greedy: \n#{instancia}\n"
        
        QAP.greedy_v2 instancia
        puts "Instancia tras greedy 2: \n#{instancia}\n"
        
        QAP.opt2 instancia
        puts "Instancia tras 2-opt: \n#{instancia}\n"
    end
end
