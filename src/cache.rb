#!/usr/bin/env ruby
#encoding utf8

def cache(petitions, size)
	p_reducido = petitions.chunk{|x| x}.map(&:first)
	fallos = 0

	cache = p.uniq.slice(0, size - 1)

	p.each_with_index { |peticion, i| 
		if !cache.member?(peticion)
			
			
			fallos += 1
		end
	}
end


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
