#!/usr/bin/env ruby
# encoding: utf-8

module QAP
  
  class QAP
    def initialize(filename)
      # Lectura del archivo del problema QAP.
      File.open(filename, "r") do |file|
        lines = file.readlines
        @size = lines[0]
        @distances = Matrix.zero(size)
        @weights = Matrix.zero(size)

        distances.each do |a|
          a = file.read().to_i
        end
      end
    end

  end
  
end
