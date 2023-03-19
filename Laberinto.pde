/*
 Desarrollada por: Laura Cortés-Rico
 Clase: Laberinto
 Atributos:
   - char[][] laberinto:     Es una matriz de caracteres que representa el laberinto. 
   - char ultimaJugada:      Almacena el caracter que estaba en la matriz de laberinto en la posición actualmente ocupada por el jugador, para restaurarla una vez se mueva el jugador
   - int[] posicionJugador:  Arreglo de dos posiciones, donde la primera posición (0) almacena la fila del jugador y la segunda posición (1) almacena la columna   
   - boolean jugando:        Bandera que está en true si el jugador no ha llegado a la meta (el juego está activo). Se pone en false cuando el jugador llega a la meta.
   - PImage jugador, jugador0, jugadorF, muro, bandera, inicio, libre: Imágenes para dibujar el laberinto
 Métodos:
  + Laberinto(String file):            Constructor que recibe como parámetro el nombre del archivo que representa el laberinto. 
  + void draw():                       Función para dibujar el laberinto
  + void mover(char direccion):        Función para mover al jugador en el laberinto. Recibe como parámetro un caracter que representa la dirección del movimiento. 
  + void reiniciar():                  Función que ubica al jugador en la posición inicial.  
  + int[] getInicio():                 Función que retorna un arreglo de dos posiciones, donde la primera posición guarda la fila del cuadro inicial, y la segunda guarda la columna del cuadro inicial.
  + int[] getFin():                    Función que retorna un arreglo de dos posiciones, donde la primera posición guarda la fila del cuadro meta, y la segunda guarda la columna del cuadro meta.
  + int[] getJugador():                Función que retorna la posición en la que se encuentra el jugador. La retorna como un arreglo de dos posiciones: [fila,columna]
  + char[][] getLaberinto():           Función que retorna la matriz laberinto. 
  + int[] getTamanho():                Función que retorna un arreglo que representa el tamaño del laberinto: [cantidadFilas,cantidadColumnas]
  - int[] getPosicion(char caracter):  Función privada que retorna la primera posición en la que encuentra el caracter que recibe como parámetro. Retorna la posición en forma de arreglo [fila,columna]
  - void leerArchivo(String f):        Función privada que lee el archivo guardado con el nombre que se recibe como parámetro. Construye la matriz a partir del archivo. 
*/
class Laberinto {
  private char[][] laberinto;
  private char ultimaJugada;
  private int[] posicionJugador;
  private PImage jugador, jugador0, jugadorF, muro, bandera, inicio, libre;
  private boolean jugando=true;

  Laberinto(String file) {
    posicionJugador=new int[2];
    jugador=loadImage("player.png");
    jugador0=loadImage("player0.png");
    jugadorF=loadImage("winner.png");
    muro=loadImage("wall.png");
    bandera=loadImage("flag.png");
    inicio=loadImage("initial.png");
    libre=loadImage("free.png");    
    cargarLaberinto(file);
    ultimaJugada='*';
    posicionJugador=getPosicion('*');
    laberinto[posicionJugador[0]][posicionJugador[1]]='j';
  }

  public boolean cargarLaberinto(String f) {
    BufferedReader reader;
    StringBuilder reading = new StringBuilder();
    String line;
    reader = createReader(f);
    try {          
      while ( (line = reader.readLine()) != null) {
        reading.append(line);
        reading.append('\n');
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
      line = null;
      return false;
    }

    String readLines=reading.toString();
    String[] rows = split(readLines, '\n'); 
    if (rows!=null)
      if (rows.length>1)
        laberinto=new char[rows.length-1][rows[0].length()];
    for (int r=0; r<rows.length-1; r++) 
      for (int c=0; c<rows[r].length(); c++)
        laberinto[r][c]=rows[r].charAt(c);
    return true;
  }

  public void draw() {    
    background(0);
    if (laberinto.length>0) {
      int ancho=(laberinto[0].length)*48;
      int alto=(laberinto.length)*48;
      int x=width/2-ancho/2;
      int y=height/2-alto/2;       
      for (int f=0; f<laberinto.length; f++) 
        for (int c=0; c<laberinto[0].length; c++) 
          switch(laberinto[f][c]) {
          case '#':
            image(muro, x+c*48, y+f*48);
            break;
          case '.':
            image(libre, x+c*48, y+f*48);
            break;
          case 'j':
            if (ultimaJugada=='-')
              image(jugadorF, x+c*48, y+f*48);
            if (ultimaJugada=='*')
              image(jugador0, x+c*48, y+f*48);
            if (ultimaJugada=='.')
              image(jugador, x+c*48, y+f*48);
            break;
          case '-':          
            image(bandera, x+c*48, y+f*48);
            break;
          case '*':
            image(inicio, x+c*48, y+f*48);
            break;
          }
    }
  }
  public void mover(char direccion) {
    if (jugando) {
      int f=posicionJugador[0];
      int c=posicionJugador[1];    
      switch(direccion) {
      case 'd'://Derecha      
        if ((c+1)<laberinto[f].length) {
          if (laberinto[f][c+1]!='#') {
            laberinto[f][c]=ultimaJugada;
            ultimaJugada=laberinto[f][c+1];
            laberinto[f][c+1]='j';
            posicionJugador[1]=c+1;
          }
        }
        break;
      case 'i'://Izquierda
        if ((c-1)>=0) {
          if (laberinto[f][c-1]!='#') {
            laberinto[f][c]=ultimaJugada;
            ultimaJugada=laberinto[f][c-1];
            laberinto[f][c-1]='j';
            posicionJugador[1]=c-1;
          }
        }
        break;
      case 'a'://Arriba
        if ((f-1)>=0) {
          if (laberinto[f-1][c]!='#') {
            laberinto[f][c]=ultimaJugada;
            ultimaJugada=laberinto[f-1][c];
            laberinto[f-1][c]='j';
            posicionJugador[0]=f-1;
          }
        }
        break;
      case 'b'://Abajo
        if ((f+1)<laberinto.length) {
          if (laberinto[f+1][c]!='#') {
            laberinto[f][c]=ultimaJugada;
            ultimaJugada=laberinto[f+1][c];
            laberinto[f+1][c]='j';
            posicionJugador[0]=f+1;
          }
        }
        break;
      case 't'://Teletransporte
        int fDestino=laberinto.length-f-1;
        int cDestino=laberinto[f].length-c-1;        
        if (laberinto[fDestino][cDestino]!='#') {
          laberinto[f][c]=ultimaJugada;
          ultimaJugada=laberinto[fDestino][cDestino];
          laberinto[fDestino][cDestino]='j';
          posicionJugador[0]=fDestino;
          posicionJugador[1]=cDestino;
        }
        break;
      }
      if (ultimaJugada=='-')
        jugando=false;
    }
  }
  public void reiniciar() {
    int[] posicionInicial=getPosicion('*');
    if (posicionInicial!=null) {
      int[] pJ=getPosicion('j');
      if (pJ!=null) {
        laberinto[pJ[0]][pJ[1]]=ultimaJugada;
        ultimaJugada='*';
        posicionJugador[0]=posicionInicial[0];
        posicionJugador[1]=posicionInicial[1];
        laberinto[posicionInicial[0]][posicionInicial[1]]='j';
        jugando=true;
      }
    }
  }

  public int[] getInicio() {
    if (ultimaJugada=='*')
      return posicionJugador;    
    else
      return getPosicion('*');
  }

  public int[] getFin() {
    if (ultimaJugada=='-')
      return posicionJugador;    
    else
      return getPosicion('-');
  }

  public int[] getJugador() {
    return posicionJugador;
  }

  public char[][] getLaberinto() {
    return laberinto;
  }
  
  private int[] getPosicion(char caracter) {
    for (int f=0; f<laberinto.length; f++) {
      for (int c=0; c<laberinto[f].length; c++) {
        if (laberinto[f][c]==caracter) {
          int[] posicion=new int[2];
          posicion[0]=f;
          posicion[1]=c;
          return posicion;
        }
      }
    }
    return null;
  }
}