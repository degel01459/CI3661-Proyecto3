# Kevin Briceño 15-11661

require 'shoes'
require_relative 'jugadas'
require_relative 'estrategias'

Shoes.app(title: "Piedra, Papel, Tijera, Lagarto, Spock", width: 800, height: 650) do
  
  # --- Estado del juego ---
  @jugador1 = nil
  @jugador2 = nil
  @j1 = nil
  @j2 = nil
  @score = [0, 0]
  @ronda_actual = 0
  @target = 5
  @modo = :alcanzar 
  @last_move_j2 = nil 
  @last_move_j1 = nil 
  @game_started = false
  @img_j1_el = nil
  @img_j2_el = nil

  # --- SECCIÓN DE CONFIGURACIÓN ---
  stack margin: 20 do
    title "Configuración de Partida", align: "center"
    
    flow margin: 10 do
      para "Modo de juego: ", align: "left"
      list_box items: ["Alcanzar N puntos", "Jugar N rondas"], width: 150 do |lista|
        @modo = lista.text.include?("Alcanzar") ? :alcanzar : :rondas
      end
      para " N: ", align: "left"
      @input_n = edit_line text: "1", width: 30, height: 20
    end

    # --- SECCIÓN DE ESTRATEGIAS ---
    flow do
      stack width: "50%", margin_left: 75 do
        para "Jugador 1 (Izquierda)"
        @strat1_list = list_box items: ["Uniforme", "Sesgada", "Copiar", "Pensar", "Manual"]
      end
      stack width: "50%", margin_left: 75 do
        para "Jugador 2 (Derecha)"
        @strat2_list = list_box items: ["Uniforme", "Sesgada", "Copiar", "Pensar"]
      end
    end

    # --- SECCIÓN DE BOTONES ---
    button "Iniciar Partida", width: "100%", height: 40, margin_top: 20 do
      all_moves = [:Piedra, :Papel, :Tijera, :Lagarto, :Spock]

      # --- LOGICA DE JUGADOR 1 ---
      case @strat1_list.text
      when "Uniforme" then @j1 = Uniforme.new(all_moves)
      when "Pensar"   then @j1 = Pensar.new
      when "Copiar"   then @j1 = Copiar.new
      when "Sesgada"  then pesos = {:Piedra => 40, :Papel => 15, :Tijera => 15, :Lagarto => 15, :Spock => 15}; @j1 = Sesgada.new(pesos)
      when "Manual"   then @j1 = Manual.new 
      else @j1 = Uniforme.new(all_moves)
      end

      # --- LOGICA DE JUGADOR 2 ---
      case @strat2_list.text
      when "Uniforme" then @j2 = Uniforme.new(all_moves)
      when "Pensar"   then @j2 = Pensar.new
      when "Copiar"   then @j2 = Copiar.new
      when "Sesgada"  then pesos = {:Piedra => 15, :Papel => 15, :Tijera => 15, :Lagarto => 40, :Spock => 15}; @j2 = Sesgada.new(pesos)
      else @j2 = Uniforme.new(all_moves)
      end

      # --- INICIAR PARTIDA ---
      @target = @input_n.text.to_i
      @game_started = true
      @ronda_actual = 0
      @score = [0, 0]
      @lbl_score.text = "0 - 0" if defined?(@lbl_score) && @lbl_score
      alert("¡Partida iniciada!")
    end
  end
  # --- FIN SECCIÓN DE CONFIGURACIÓN ---

  # --- ÁREA DE JUEGO VISUAL ---
  flow margin: 10, padding: 10 do

    # --- AREA DE JUGADOR 1 ---
    @img_j1 = stack width: "20%", margin_left: 20, align: "left", height: 150 do
      para "J1", width: "20%", align: "center", margin_left: 20, margin_top: 10, weight: "bold"
    end

    # --- MARCADOR ---
    stack width: "50%", align: "center" do
      @lbl_score = title "0 - 0", align: "center", margin_bottom: 20
      para "Seleccione jugada (Si J1 es Manual):", align: "center", margin_bottom: 10
      # --- BOTONES DE JUGADA ---
      flow do
        # --- OPCIONES DE JUGADA ---
        [:Piedra, :Papel, :Tijera, :Lagarto, :Spock].each do |opcion|
          button opcion.to_s, width: 75, height: 75, align: "center" do
            if @game_started
              if @j1.is_a?(Manual)
                @j1.jugada_elegida = opcion
                jugar_ronda  # --- Avanzar ronda
              else
                alert("El Jugador 1 no está en modo Manual. Usa 'Siguiente Ronda'.")
              end
            end
          end
        end
      end

      # --- BOTON "SIGUIENTE RONDA" ---
      @btn_next = button "Siguiente Ronda Automática", width: "100%", align: "center", margin: 20 do
        jugar_ronda if @game_started
      end
    end

    # --- AREA DE JUGADOR 2 ---
    @img_j2 = stack width: "15%", margin_left: 10, align: "right", height: 150 do
       para "J2 (Bot)", width: "15%", align: "center", margin_left: 10, margin_top: 10, weight: "bold"
    end
  end

  # --- MÉTODOS DE LÓGICA ---
  def jugar_ronda
    # --- VERIFICAR SI EL JUEGO HA TERMINADO ---
    if (@modo == :alcanzar && (@score[0] >= @target || @score[1] >= @target)) ||
       (@modo == :rondas && @ronda_actual >= @target)
       alert("¡Juego Terminado! Ganador: #{@score[0] > @score[1] ? 'J1' : 'J2'}")
       return
    end

    # --- JUGAR RONDA ---
    begin
      move1 = @j1.prox(@last_move_j2)
    rescue => e
      alert("Error obteniendo mov J1: #{e.message}")
      return
    end

    begin
      move2 = @j2.prox(@last_move_j1)
    rescue => e
      alert("Error obteniendo mov J2: #{e.message}")
      return
    end

    # --- ACTUALIZAR RONDA ---
    @last_move_j1 = move1
    @last_move_j2 = move2

    # --- CALCULAR PUNTOS ---
    begin
      ptos = move1.puntos(move2)
    rescue => e
      alert("Error al calcular puntos: #{e.message}")
      return
    end

    @score[0] += ptos[0]
    @score[1] += ptos[1]
    @ronda_actual += 1

    # --- ACTUALIZAR VISTA ---
    actualizar_vista(move1, move2)
    begin
      if defined?(@j1) && @j1.is_a?(Manual)
        # puts "[jugar_ronda] Limpiando selección manual anterior: #{@j1.jugada_elegida.inspect}"
        @j1.jugada_elegida = nil
      end
    rescue => e
      puts "[jugar_ronda] Error al limpiar selección manual: #{e.message}"
    end
  end

  def actualizar_vista(m1, m2)

    # puts "actualizar_vista: m1=#{m1.inspect}, m2=#{m2.inspect}"

    @lbl_score.text = "#{@score[0]} - #{@score[1]}" if defined?(@lbl_score) && @lbl_score

    path_j1 = File.join(File.dirname(__FILE__), "#{m1.to_s}.png")
    path_j2 = File.join(File.dirname(__FILE__), "#{m2.to_s}.png")

    # --- Actualizamos J1 ---
    begin
      @img_j1_el.remove if @img_j1_el
    rescue
    end

    @img_j1.clear do
      para "J1: #{m1.to_s}", align: "center"
      if File.exist?(path_j1)
        begin
          @img_j1_el = image path_j1, width: 75, height: 75, align: "center"
        rescue => e
          rect 0, 0, 50, 50, fill: gray
          para "error al cargar imagen", size: 8
          @img_j1_el = nil
        end
      else
        rect 0, 0, 50, 50, fill: gray
        para "imagen no encontrada", size: 8
        @img_j1_el = nil
      end
    end

    # --- Actualizamos J2 ---
    begin
      @img_j2_el.remove if @img_j2_el
    rescue
    end

    @img_j2.clear do
      para "J2: #{m2.to_s}", align: "center"
      if File.exist?(path_j2)
        begin
          @img_j2_el = image path_j2, width: 75, height: 75, align: "center"
        rescue => e
          rect 0, 0, 50, 50, fill: gray
          para "error al cargar imagen", size: 8
          @img_j2_el = nil
        end
      else
        rect 0, 0, 50, 50, fill: gray
        para "imagen no encontrada", size: 8
        @img_j2_el = nil
      end
    end
  end

end
