# Proyecto III: Piedra, Papel, Tijera, Lagarto, Spock (Ruby)

**Laboratorio de Lenguajes de Programación I (CI-3661) Universidad Simón Bolívar**

- **Nombres:** Kevin Briceño
- **Carnets:** 15-11661
- **Correo:** `15-11661@usb.ve`

## Estructura del Proyecto

El archivo entregable sigue la estructura solicitada, con las fuentes y recursos en la carpeta raíz para su correcta ejecución:

```bash
CI3661-Proyecto3
├─ Estrategias.rb           # Lógica de Inteligencia Artificial
├─ Jugadas.rb               # Lógica de reglas del juego
├─ main.rb                  # Archivo principal - Interfaz Gráfica
├─ Piedra.png               # Imagen de jugada piedra
├─ Papel.png                # Imagen de jugada papel
├─ Tijera.png               # Imagen de jugada tijera
├─ Lagarto.png              # Imagen de jugada lagarto
├─ Spock.png                # Imagen de jugada spock
├─ README.md                # Documentación
└─ Proyecto_3.pdf           # Enunciado original
```

## Instalación y Ejecución

Este proyecto utiliza la librería gráfica Shoes. Debido a requerimientos de la librería, se debe utilizar JRuby.

#### Prerrequisitos

- JRuby (recomendado: versión 9.x compatible con tu entorno Shoes).
- Gem `shoes` instalada para JRuby.

#### Pasos para ejecutar

Instalar la dependencia de Shoes:

```bash
jruby -S gem install shoes
o
jruby -S gem install shoes --pre
```

Ejecutar el archivo principal desde la terminal:

```bash
jruby main.rb
```

### Descripción

El objetivo del proyecto fue implementar el juego extendido popularizado por The Big Bang Theory, haciendo énfasis en la Programación Orientada a Objetos y el manejo de Interfaces Gráficas (GUI).

#### 1. Reglas del Juego

Es la versión popularizada por The Big Bang Theory. Debes programar las 10 interacciones posibles:

- Tijera corta Papel
- Tijera decapita Lagarto
- Papel tapa Piedra
- Papel desautoriza Spock
- Piedra aplasta Lagarto
- Piedra aplasta Tijera
- Lagarto envenena Spock
- Lagarto devora Papel
- Spock rompe Tijera
- Spock vaporiza Piedra

#### 2. Arquitectura del Código

El sistema es modular y se divide en tres componentes principales:

##### A. Modelo de Jugadas (Jugadas.rb)

Se implementó una clase padre Jugada y 5 subclases (Piedra, Papel, Tijera, Lagarto, Spock).

- Cada clase maneja su propia representación (to_s).
- El método puntos(contrincante) determina el ganador de la ronda devolviendo un par [puntos_propios, puntos_contrario].

##### B. Estrategias de IA (Estrategias.rb)

Se creó una clase padre Estrategia que define el comportamiento de los jugadores mediante el método prox. Las estrategias implementadas son:

- Manual: Permite al usuario seleccionar su jugada.
- Uniforme: Selección aleatoria simple.
- Sesgada: Selección aleatoria basada en pesos/probabilidades definidos.
- Copiar: Replica la última jugada del oponente.
- Pensar: Analiza el historial del oponente para predecir y vencer su jugada más probable.

#### 3. Interfaz Gráfica (main.rb)

Utilizando la gema Shoes, la clase Partida gestiona el flujo del juego.

- Permite configurar nombres y estrategias dinámicamente.
- Muestra visualmente las jugadas con imágenes y actualiza el marcador.
- Soporta los modos de juego "Por Rondas" y "Alcanzar Puntaje".
