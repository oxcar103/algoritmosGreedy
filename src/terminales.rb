#!/usr/bin/env ruby
# encoding: utf-8

def cambio (monedas, precio)
  vuelta = []

  monedas.sort.reverse.each { |moneda|
    numero_monedas = precio / moneda
    precio = precio - numero_monedas*moneda

    vuelta.push [moneda, numero_monedas]
  }

  return vuelta
end
