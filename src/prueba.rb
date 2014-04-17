#!/usr/bin/env ruby
# encoding: utf-8

class Prueba
    def initialize
        @a=[0,1,2]
    end
    
    def self.metodo(instancia)
        instancia = Prueba.new
        #puts instancia
    end
    
    def to_s
        a.to_s
    end
    attr_accessor:a
end

if __FILE__==$0
    p=Prueba.new
    p.a=[4,5,6]
    Prueba.metodo p
    puts p
end