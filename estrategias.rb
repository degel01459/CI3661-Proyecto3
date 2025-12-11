# Kevin Briceño 15-11661

require_relative 'jugadas'

class Estrategia
  def prox(jugada_anterior_oponente)
    raise "Este método debe ser implementado por la subclase"
  end

  def crear_jugada(nombre)
    name = nombre.to_s
    begin
      Object.const_get(name).new
    rescue NameError
      raise "Clase de jugada '#{name}' no encontrada. Verifica `jugadas.rb`."
    end
  end
end

class Uniforme < Estrategia
  def initialize(lista_posibles)
    @posibles = lista_posibles.map(&:to_s).uniq
  end

  def prox(jugada_anterior_oponente)
    eleccion = @posibles.sample
    crear_jugada(eleccion)
  end
end

class Sesgada < Estrategia
  def initialize(mapa_pesos)
    @mapa = {}
    mapa_pesos.each do |k, v|
      unless v.is_a?(Numeric) && v >= 0
        raise ArgumentError, "Peso inválido para #{k}: #{v} (debe ser número >= 0)"
      end
      @mapa[k.to_s] = v.to_f
    end
    @total_peso = @mapa.values.sum
    if @total_peso <= 0
      raise ArgumentError, "La suma de pesos debe ser mayor que 0"
    end
  end

  def prox(jugada_anterior_oponente)
    r = rand * @total_peso
    acumulado = 0.0
    @mapa.each do |jugada, peso|
      acumulado += peso
      return crear_jugada(jugada) if r <= acumulado
    end
    crear_jugada(@mapa.keys.last)
  end
end

class Copiar < Estrategia
  def prox(jugada_anterior_oponente)
    if jugada_anterior_oponente.nil?
      return Uniforme.new([:Piedra, :Papel, :Tijera, :Lagarto, :Spock]).prox(nil)
    end
    crear_jugada(jugada_anterior_oponente.class.name)
  end
end

class Pensar < Estrategia
  def initialize
    @posibles = ['Piedra', 'Papel', 'Tijera', 'Lagarto', 'Spock']
  end

  def prox(jugada_anterior_oponente)
    eleccion = @posibles.sample
    crear_jugada(eleccion)
  end
end

class Manual < Estrategia
  attr_accessor :jugada_elegida

  def initialize
    @jugada_elegida = nil
  end

  def prox(jugada_anterior_oponente)
    puts "[Manual#prox] jugada_elegida = #{@jugada_elegida.inspect}"

    if @jugada_elegida.nil?
      raise "Debes seleccionar una jugada para el jugador Manual."
    end

    crear_jugada(@jugada_elegida)
  end
end
