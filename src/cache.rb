#!/usr/bin/env ruby
#encoding utf8

# Búsqueda del elemento mayoritario. Un algoritmo:
# Escogemos parejas de elementos consecutivos repetidos
# por ejemplo:
# [1,1,2,3,3,3] => {(1,1),(2,3),(3,3)} => [1,3]
# [3,1,1,2,3,3,3,3] => {(3,1),(1,2),(3,3),(3,3)} => [3,3]
# No necesariamente el mayoritario en el nuevo es mayoritario en
# el original, pero si existe mayoritario del original entonces
# equivale al del nuevo.
# Caso base: En tamaño 2, hay elemento mayoritario si
# ambos son iguales.
#
# Eficiencia: O(n)

def farthest_in_future(p, k)
    p_reducido = []
    fallos = 0

    p.each_with_index{|element,index| p_reducido << element if element != p[index+1]}

    #No funciona, por eso lo comenté
    #cache = p.uniq.resize(k)

    p.each{|petición| 
        if !cache.include?(petición){
        #Falta traducir:
        #\STATE{Buscamos el elemento que está en caché que más tardará en volver a ser necesitado}
        #\STATE{Sustituimos este elemento por el que necesitamos tener en caché}

        fallos+=1
        }

    }

return fallos
end


if __FILE__ == $0
puts "Introduce array: "
line = gets.chomp
array = line.split.map(&:to_i)

puts "Elemento mayoritario: #{array.mayoritario}."
end
