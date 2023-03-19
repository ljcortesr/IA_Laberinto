/*
 Desarrollada por: Laura Cortés-Rico
 Clase: Nodo
 Atributos:
   
 Métodos:
 
*/
class Nodo {
  Estado estado;
  Nodo padre;
  char accion;
  int costoCamino;
  int g;
  int h;
  int profundidad;

  Nodo() {
    estado=new Estado();
    padre=null;
    costoCamino=0;
    profundidad=0;
  }
  Nodo(Estado ini) {
    estado=ini;
    padre=null;
    costoCamino=0;
    profundidad=0;
  }
  Nodo(Estado ini, char a, Nodo p, int c, int prof) {
    estado=ini;
    accion=a;
    padre=p;
    costoCamino=c;
    profundidad=prof;
  }
  Nodo(Estado ini, char a, Nodo p, int c, int heuristica, int prof) {
    estado=ini;
    accion=a;
    padre=p;
    h=heuristica;    
    costoCamino=c;
    g=h+c;
    profundidad=prof;
  }
}