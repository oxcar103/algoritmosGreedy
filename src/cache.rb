#!/usr/bin/env ruby
#encoding: utf-8

def cache(p, size)
    p_reducido = p.chunk{|x| x}.map(&:first)
    fallos = 0

    cache = p.uniq.slice(0, size)

    p.each_with_index { |peticion, i| 
        puts "Caché en #{i}: #{cache}; petición #{peticion}"
        if !cache.member? peticion
            i_a_eliminar = 0
            a_eliminar = nil

            cache.each { |e|
                index = p[i .. p.size-1].find_index(e)

                if index.nil? || index > i_a_eliminar
                    a_eliminar = e
                    i_a_eliminar = index.nil? ? p.size : index
                end
            }

            puts "Fallo en #{i}. Reemplazando #{a_eliminar} por #{peticion}"
            cache[cache.find_index a_eliminar] = peticion

            fallos += 1
        end
    }

    fallos
end

if __FILE__ == $0
puts "Introduce tamaño:"
size = gets.to_i
puts "Introduce peticiones: "
pet = gets.chomp.split.map(&:to_i)

# Pruebas
pet = [1, 6, 3, 2, 5, 3, 2, 1, 4, 1, 1, 9, 4, 4, 2, 4, 2, 1, 3, 4, 5, 2]

puts "Número de fallos: #{cache(pet, 5)}."
end
