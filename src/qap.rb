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
                
                (0..(size-1)).to_a.each{|i|
                    @distances[i]=file.readline.chomp.split(" ").map &:to_i
                }
      
                file.eat_empty_lines
                
                (0..(size-1)).to_a.each{|i|
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
    end

    if __FILE__ == $0
        puts "Introduce nombre de archivo: "
        file = gets.chomp
        instancia = QAP.new(file)
        QAP.opt2 instancia
    end
end