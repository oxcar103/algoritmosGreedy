#!/usr/bin/env ruby
# encoding: utf-8

class File
    def eat_empty_lines
        while true
            if ((c=getc) != "\n")
                ungetc(c)
                break
            end
        end
    end
end

module QAP
    class QAP
        def initialize(filename)
            # Lectura del archivo del problema QAP.
            File.open(filename, "r") do |file|
                @size = file.readline.to_i
                file.eat_empty_lines

                @permutation = (0..(size-1)).to_a
                @distances = Array.new(size)
                @weights = Array.new(size)
                
                (0..(size-1)).each{|i|
                    @distances[i]=file.readline.chomp.split(" ").map &:to_i
                }
      
                file.eat_empty_lines
                
                (0..(size-1)).each{|i|
                    @weights[i]=file.readline.chomp.split(" ").map &:to_i
                }
            end
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
            (0..(size-1)).each do |i|
                (0..(size-1)).each do |j|
                    total_cost = total_cost + weight(i,j)*distance(permutation[i], permutation[j])
                end
            end
            return total_cost
        end

        def self.opt2(qap)
            continue = true
            
            while continue
                continue = false
                
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
        
        def self.greedy_v1(qap)
            min = qap.cost
            result = qap
            s = qap.size-1

            (0..s).each do |k|
                fab_asignada = Array.new(s+1){false}
                loc_asignada = Array.new(s+1){false}
                actual = qap.clone
                
                (1..s).inject(k) do |i|
                    fab_asignada[i] = true
                    loc_asignada[actual.permutation[i]] = true
                    
                    max_w_index = (0..s).each_with_index.select{|j| !fab_asignada[j[0]]}.collect{|j| [actual.weight(k,j[0]),j[-1]]}.max[-1]
                    min_d_index = (0..s).each_with_index.select{|j| !loc_asignada[j[0]]}.collect{|j| [actual.distance(actual.permutation[k],j[0]),j[-1]]}.min[-1]
 
                    actual.permutation[max_w_index] = min_d_index
                    max_w_index
                end
                
                if actual.cost < min
                    result = actual
                end
            end
            qap = result
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
    end

    if __FILE__ == $0
        puts "Introduce nombre de archivo: "
        file = gets.chomp
        instancia = QAP.new(file)
        puts "\t Coste inicial: #{instancia.cost}"
        
        QAP.greedy_v1 instancia
        puts "Instancia tras greedy: \n\t #{instancia.permutation.to_s}"
        puts "\t Coste: #{instancia.cost}"
        
        QAP.opt2 instancia
        puts "Instancia tras 2-opt: \n\t #{instancia.permutation.to_s}"
        puts "\t Coste: #{instancia.cost}"
    end
end