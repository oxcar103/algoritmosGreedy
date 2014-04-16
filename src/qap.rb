#!/usr/bin/env ruby
# encoding: utf-8
require 'matrix'


module QAP
    
    class QAP
        def initialize(filename)
            # Lectura del archivo del problema QAP.
            File.open(filename, "r") do |file|
                lines = file.readlines
                @size = lines[0]
                @permutation = (0..(size-1)).to_a
                @distances = Matrix.zero(size)
                @weights = Matrix.zero(size)

                distances.each do |a|
                    a = file.read().to_i
                end

                weights.each do |a|
                    a = file.read().to_i
                end
            end
        end

        # Acceso público a la permutación.
        attr_accessor :permutation 
        attr_reader   :size

        # Lectura de distancias y pesos.
        def distance(i,j)
            @distances[i,j]
        end
        def weigth(i,j)
            @weights[i,j]
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
    end
    

    def 2opt(qap)
        while continue
            continue = False
            (0..(qap.size-1)).each do |i|
                ((i+1)..(qap.size-1)).each do |j|
                    old_cost = qap.cost
                    qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i] 
                    new_cost = weight(i,j)*distance(permutation[j],permutation[i])
                    if old_cost <= new_cost
                        qap.permutation[i], qap.permutation[j] = qap.permutation[j],qap.permutation[i]
                        continue = True
                    end
                end
            end
        end
    end
end


