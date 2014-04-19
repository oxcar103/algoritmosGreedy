#!/usr/bin/env ruby
# encoding: utf-8

class Lesson < Array
    def initialize(s_hour,s_min,f_hour,f_min)
        # Chanchullo para poder representar la hora de inicio y finalización
        push Time.new(1970,1,1,s_hour,s_min)
        push Time.new(1970,1,1,f_hour,f_min)
    end
    
    def solapa(otra)
        (self[0] <= otra[0] && otra[0] <= self[1]) || (self[0] <= otra[1] && otra[1] <= self[1]) ||
        (self[0] >= otra[0] && otra[0] >= self[1]) || (self[0] >= otra[1] && otra[1] >= self[1])
end


class Scheduling
    def initialize(clases)
        @clases=clases
    end
    
    def planifica
        adyacentes = Array.new(clases.size){Array.new(clases.size)}
        
        (0,..,clases.size-1).each do |i|
            # Hacemos 0 en la diagonal de la matriz de adyacencia...
            adyacentes[i][i] = false
            (i+1,...,clases.size-1).each do |j|
                adyacentes[i][j] = adyacentes[j][i] = clases[i].solapa clases[j]
            end
        end
        
        sin_colorear = (0..clases.size-1).to_a
        vertices = []
        index = 0
        
        while !sin_colorear.empty?
            vertices[index] = [sin_colorear.shift]
            
            actualizados = []
            
            sin_colorear.each do |v|
                if !(vertices[index].collect{ |u| adyacentes[v][u] }.member? true)
                    vertices[index] << v
                    actualizados << v
                end
            end
            
            sin_colorear = sin_colorear - actualizados
            index+=1
        end
        
        vertices.map{ |i| i.map{ |j| clases[j] } }  
    end
end

if __FILE__==$0
    clases = []
    
    # Forma de entrada de datos: 
    #           8:30 9:30
    #           10:50 11:50       
    while c=gets.chomp
        c.split!(/[:," "]/)
        clases << Lesson.new(c[0],c[1],c[2],c[3])
    end
    # Línea de prueba para depuración:
    #clases= [Lesson.new(7,30,10,30), Lesson.new(7,45,8,50), Lesson.new(11,30,12,45),Lesson.new(12,30,13,40)]
    
        
    centro_educativo = Scheduling.new(clases)
    p "Se necesitan  #{centro_educativo.planifica.to_s.size} aulas para albergar las clases"
end