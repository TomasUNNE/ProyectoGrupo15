# Optimización de consultas a través de índices



SQLSERVER considera a los índices como estructuras de datos en disco utilizadas con el fin de reducir el tiempo y mejorar la eficiencia de las consultas realizadas a una tabla determinada. Estos índices contienen copias de los datos de la tabla, organizados con una estructura B-árbol que permite a SQLSERVER encontrar las filas asociadas a los valores de clave rápida y eficientemente. Al ejecutar una consulta, el optimizador de consultas se encarga de evaluar cada método disponible para recuperar los datos. Luego, selecciona el más eficiente.



## Estructura de los índices

Ahondando en la estructura de los índices, un B-árbol es una estructura auto-balanceada capaz de organizar las copias de los datos de la tabla en diferentes nodos lógicos, facilitando y optimizando las operaciones de búsqueda. 

Los nodos de un B-árbol se dividen en diferentes categorías o niveles:

* Nodo raíz: nivel superior del árbol. Se considera como el punto de partida de la búsqueda.
* Nodos intermedios: aquellos que contienen rangos de claves y punteros a los nodos de nivel inferior
* Nodos hoja: en ellos se almacena la información real delas claves del índice.



## Tipos de índices:

Los índices se pueden dividir en dos tipos principales.

* Clustered: determina el orden físico de almacenamiento de los datos en la tabla. Únicamente existe uno por tabla. Los nodos hoja de este tipo de índice contienen datos completos de la tabla.
* Nonclustered: es una estructura que contiene las claves seleccionadas y un puntero a la ubicación real de los datos. Es posible tener múltiples índices nonclustered por tabla. Sus nodos hojas contienen unicamente las claves del índice y punteros a la fila de datos.



## 

