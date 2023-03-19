/*
 Desarrollada por: Laura Cortés-Rico
 Clase: InteligenciaArtificial
 Atributos:
   ambiente: Atributo que representa el lugar en el que actua el agente racional: el laberinto. 
   frontera: Lista de Nodos que conforman la frontera. 
   cerrada: Lista de estados repetidos. 
 Métodos:
   funcionSucesor: recibe un estado y retorna todos los posibles sucesores de ese estado, como una lista de tipo AccionSucesor.
   valida: recibe un estado y determina si es válido (y si no está repetido - en la lista de cerrado-). 
   testObjetivo: recibe un estado y retornar true si es el objetivo y false si no lo es. 
   resolver: Es la función principal, llamada de forma externa para resolver una búsqueda con IA. Recibe como parámetro el estado inicial y un caracter que representa el tipo de búsqueda.
   
 */
class InteligenciaArtificial {
  Laberinto ambiente;  
  ArrayList<Nodo> frontera=new ArrayList<Nodo>();
  ArrayList<Estado> cerrada=new ArrayList<Estado>(); 

  InteligenciaArtificial(Laberinto amb) {
    ambiente=amb;
    frontera=new ArrayList<Nodo>();
    cerrada=new ArrayList<Estado>();
  }

  private ArrayList<AccionSucesor> funcionSucesor(Estado estado) {
    //Dadas todas las posibles acciones, debe retorna la lista de todas las acciones posibles, con el estado siguiente. 
    //Una acción es posible si el jugador no se estrella con un muro y si el estado siguiente no está repetido
    ArrayList<AccionSucesor> listaSucesores=new ArrayList<AccionSucesor>();
    //Arriba
    Estado auxiliar=new Estado(estado.x, estado.y-1);
    if (valida(auxiliar)) {      
      listaSucesores.add(new AccionSucesor('i', auxiliar));
    }     
    //Abajo
    auxiliar=new Estado(estado.x, estado.y+1);
    if (valida(auxiliar)) {
      listaSucesores.add(new AccionSucesor('d', auxiliar));
    }    
    //Izquierda    
    auxiliar=new Estado(estado.x-1, estado.y);
    if (valida(auxiliar)) {
      listaSucesores.add(new AccionSucesor('a', auxiliar));
    }    
    //Derecha
    auxiliar=new Estado(estado.x+1, estado.y);
    if (valida(auxiliar)) {
      listaSucesores.add(new AccionSucesor('b', auxiliar));
    }    
    //Teletransporte
    auxiliar=new Estado(ambiente.laberinto.length-1-estado.x, ambiente.laberinto[0].length-1-estado.y);
    if (valida(auxiliar)) {
      listaSucesores.add(new AccionSucesor('t', auxiliar));
    }      
    return listaSucesores;
  }

  private boolean valida(Estado estado) {
    //Verifica que la posición sea válida, es decir que no esté fuera del tablero
    if (estado.x<0 || estado.y<0)
      return false;
    if (estado.x>=ambiente.laberinto.length || estado.y>=ambiente.laberinto[0].length)
      return false;
    //Verifica que la posición sea válida, es decir que no ubique al jugador sobre un muro  
    if (ambiente.laberinto[estado.x][estado.y]=='#')
      return false;
    //Solo si la posición en el tablero es válida, empieza a revisar todos los estados previos
    //Si es el estado ya existe, entonces no la ubica como una casilla (estado) válida. 
    if (cerrada==null)
      return true;
    else {
      for (int e=0; e<cerrada.size(); e++) {
        Estado estadoCerrada=cerrada.get(e);
        if (estadoCerrada.x==estado.x && estadoCerrada.y==estado.y) //Si el estado está repetido (en la lista cerrada), no lo incluye como un posible sucesor.
          return false;
      }
    }    
    return true;
  }

  private boolean testObjetivo(Estado estado) {
    int[] posFinal=lab.getFin();
    if (estado.x==posFinal[0] && estado.y==posFinal[1])
      return true;
    return false;
  }

  public IntList resolver(Estado inicial, char tipo) {
    //Independiente del tipo de búsqueda, el árbol de solución inicia con el nodo raíz, que es el estado inicial
    Nodo raiz=new Nodo(inicial); //Revisar los constructores de la clase Nodo. 
    frontera.add(raiz);

    switch(tipo) {
      //Primero en Anchura
    case 'a':
    case 'A': 
      return BPA(inicial);      
      //Primero en Profundidad
    case 'p':
    case 'P':
      return BPP(inicial);      
      //A*
    case 'e':
    case 'E': 
      return BAE(inicial);      
    default: 
      println("Método inválido");
    }
    return null;
  }

  private IntList BPA(Estado inicial) {
    for (int n=0; n<frontera.size(); n++) {      
      Nodo nAux=frontera.get(n);               
      if (!testObjetivo(nAux.estado)) {//Si ese nodo NO contiene el estado objetivo
        //Se agrega a cerrado
        cerrada.add(new Estado(nAux.estado.x, nAux.estado.y));
        ArrayList<AccionSucesor> expansion = funcionSucesor(nAux.estado);
        if (expansion!=null) {// Si el nodo se puede expandir (No es nodo hoja)                  
          for (int e=0; e<expansion.size(); e++) {//Por cada estado de la lista de expansión
            //Se crea el nodo 
            AccionSucesor aS=expansion.get(e);
            Nodo nuevo=new Nodo(aS.sucesor, aS.accion, nAux, nAux.costoCamino+1, nAux.profundidad+1);
            //Se agrega a la frontera
            frontera.add(nuevo);
          }
        }
      } else {
        IntList retorno=new IntList();
        retorno.append(nAux.accion);
        for (int nodo=frontera.size()-1; nodo>=0; nodo--) {
          if (nAux.padre==frontera.get(nodo)) {
            nAux=frontera.get(nodo);
            retorno.append(nAux.accion);
          }
        }          
        return retorno;
      }
    }
    return null;
  }

  private IntList BPP(Estado inicial) {
    while (frontera!=null) {
      Nodo nAux=frontera.get(0);               
      if (!testObjetivo(nAux.estado)) {//Si ese nodo NO contiene el estado objetivo
        //Se agrega a cerrado
        cerrada.add(new Estado(nAux.estado.x, nAux.estado.y));
        ArrayList<AccionSucesor> expansion = funcionSucesor(nAux.estado);
        if (expansion!=null && expansion.size()!=0) {// Si el nodo se puede expandir (No es nodo hoja)          
          for (int e=0; e<expansion.size(); e++) {//Por cada estado de la lista de expansión
            //Se crea el nodo 
            AccionSucesor aS=expansion.get(e);
            Nodo nuevo=new Nodo(aS.sucesor, aS.accion, nAux, nAux.costoCamino+1, nAux.profundidad+1);
            //Se agrega a la lista frontera, pero a la izquierda
            frontera.add(e, nuevo);
          }
        } else {
          //Si es un nodo hoja, y no es el objetivo, entonces se elimina de la lista          
          do {             
            nAux=nAux.padre;
            frontera.remove(0);
            if (nAux==null) {//Ya no hay nodos en la frontera, por lo tanto no hay solución
              return null;
            }
          } while (nAux.padre==frontera.get(1));
        }
      } else {//Si el primer nodo es el objetivo
        IntList retorno=new IntList();
        retorno.append(nAux.accion);
        for (int nodo=1; nodo<=frontera.size()-1; nodo++) {
          if (nAux.padre==frontera.get(nodo)) {
            nAux=frontera.get(nodo);
            retorno.append(nAux.accion);
          }
        }          
        return retorno;
      }
    }
    return null;
  }

  private IntList BAE(Estado inicial) {
    while (frontera!=null) {
      Nodo nAux=frontera.get(0);               
      if (!testObjetivo(nAux.estado)) {//Si ese nodo NO contiene el estado objetivo
        //Se agrega a cerrado
        cerrada.add(new Estado(nAux.estado.x, nAux.estado.y));
        ArrayList<AccionSucesor> expansion = funcionSucesor(nAux.estado);
        if (expansion!=null && expansion.size()!=0) {// Si el nodo se puede expandir (No es nodo hoja)
          int[] posFinal=lab.getFin(); 
          //Se toma el primer nodo hijo
          AccionSucesor aS=expansion.get(0); 
          //Se calcula la heurística (en este caso, distancia Manhattan de la posición del jugador a la posición final). 
          int heuristica=Math.abs(aS.sucesor.x-posFinal[0])+Math.abs(aS.sucesor.y-posFinal[1]);            
          Nodo nuevo=new Nodo(aS.sucesor, aS.accion, nAux, nAux.costoCamino+1, heuristica, nAux.profundidad+1);                        
          //Se agrega a la frontera, pero a la izquierda, luego se va a ir ordenando en términos del costo más la heurística. 
          frontera.add(0, nuevo);
          for (int e=1; e<expansion.size(); e++) {
            aS=expansion.get(e);  
            heuristica=Math.abs(aS.sucesor.x-posFinal[0])+Math.abs(aS.sucesor.y-posFinal[1]);             
            nuevo=new Nodo(aS.sucesor, aS.accion, nAux, nAux.costoCamino+1, heuristica, nAux.profundidad+1);            
            boolean banderaA=false;
            for (int e1=0; e1<e; e1++) {
              if (nuevo.g<frontera.get(e1).g) {//g es la suma del costo más la heurística. Es el que determina el orden de inserción.
                //Se agrega a la frontera, pero a la izquierda
                frontera.add(e1, nuevo);                
                e1=e;
                banderaA=true;
              }
            }
            if (banderaA==false) {
              frontera.add(expansion.size()-1, nuevo);
            }
          }
        } else {
          //Si es un nodo hoja, y no es el objetivo, entonces se elimina de la lista          
          do {             
            nAux=nAux.padre;
            frontera.remove(0);
            if (nAux==null) {//Ya no hay nodos en la frontera, por lo tanto no hay solución
              return null;
            }
          } while (nAux.padre==frontera.get(1));
        }
      } else {//Si el primer nodo es el objetivo
        IntList retorno=new IntList();
        retorno.append(nAux.accion);
        for (int nodo=1; nodo<=frontera.size()-1; nodo++) {
          if (nAux.padre==frontera.get(nodo)) {
            nAux=frontera.get(nodo);
            retorno.append(nAux.accion);
          }
        }          
        return retorno;
      }
    }
    return null;
  }
}