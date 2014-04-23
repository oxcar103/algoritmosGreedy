def cache(p, size)
    # La caché se inicia a los 'size' primeros datos (sin repetir)
    cache = p.uniq.slice(0, size)
    fallos = 0

    # Recorremos las peticiones y reemplazamos el elemento
    # conveniente cuando se produce un fallo de caché
    p.each_with_index { |peticion, i| 
        if !cache.member?(peticion)
            i_a_eliminar = 0
            i_cache = nil

            cache.each_with_index { |e, j|
                # Si no se encuentra una próxima petición se escoge este
                # elemento (find_index devuelve nil)
                prox_pet = p[i .. p.size-1].find_index(e) || p.size

                if prox_pet > i_a_eliminar
                    i_cache = j
                    i_a_eliminar = prox_pet
                end
            }

            cache[i_cache] = peticion

            fallos += 1
        end
    }

    fallos
end