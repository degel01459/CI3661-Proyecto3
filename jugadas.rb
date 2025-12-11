# Kevin Briceño 15-11661

class Jugada
  GANADORES = {
    'Tijera'  => ['Papel', 'Lagarto'],
    'Papel'   => ['Piedra', 'Spock'],
    'Piedra'  => ['Lagarto', 'Tijera'],
    'Lagarto' => ['Spock', 'Papel'],
    'Spock'   => ['Tijera', 'Piedra']
  }

  def to_s
    self.class.name
  end

  def puntos(contrincante)
    mi_clase = self.class.name
    su_clase = contrincante.class.name

    return [0, 0] if mi_clase == su_clase

    if GANADORES[mi_clase].include?(su_clase)
      return [1, 0]
    else
      return [0, 1]
    end
  end
end

# Subclases requeridas
class Piedra < Jugada; end
class Papel < Jugada; end
class Tijera < Jugada; end
class Lagarto < Jugada; end
class Spock < Jugada; end