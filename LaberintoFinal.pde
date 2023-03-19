/*
 Desarrollada por: Laura Cortés-Rico
 Clase: Principal de Processing
 Descripción: 
 
 */
Laberinto lab;
IntList solucion;

boolean recorriendo;
int p=0;

void setup() {
  size(1024, 768);
  lab=new Laberinto("lab1.txt");
}
void draw() {
  lab.draw();
  if (recorriendo && solucion!=null) {
    if (p>=0) {
      delay(200);
      char accion=(char)solucion.get(p);
      print(accion+"-");
      lab.mover(accion);     
      p--;
    } else {
      delay(200);
      recorriendo=false;
    }
  }
}

void resolver(char tipo) {
  InteligenciaArtificial inteligencia=new InteligenciaArtificial(lab);
  //Saber el estado inicial, para enviarlo a la inteligencia artificial
  int[] posicionJugador=lab.getJugador();
  Estado inicial=new Estado(posicionJugador[0], posicionJugador[1]);
  switch(tipo) {
  case 'a':
    //Resolver con búsqueda primero en anchura  
    solucion=inteligencia.resolver(inicial, 'a');  
    break;
  case 'p':
    //Resolver con búsqueda primero en profundidad  
    solucion=inteligencia.resolver(inicial, 'p');     
    break;
  case 'e':
    //Resolver con búsqueda A*  
    solucion=inteligencia.resolver(inicial, 'e');
    break;
  }

  //Ir llamando a los movimientos del laberinto
  recorriendo=true;
  p=solucion.size()-2;
}

void keyPressed() {  
  switch(keyCode) {
  case 97:
  case 65:
    //Inteligencia artificial PRIMERO EN ANCHURA
    resolver('a');
    break;
  case 112:
  case 80:
    //Inteligencia artificial
    resolver('p');
    break;
  case 101:
  case 69:
    //Inteligencia artificial
    resolver('e');
    break;
  case 38:
    lab.mover('a');
    break;
  case 40:
    lab.mover('b');
    break;
  case 39:
    lab.mover('d');
    break;
  case 37:
    lab.mover('i');
    break;
  case 32:
    lab.mover('t');
    break;
  case 82:
  case 114:
    lab.reiniciar();
    break;
  }
}