# Optimización de consultas a través de índices



SQLSERVER considera a los índices como estructuras de datos en disco utilizadas con el fin de reducir el tiempo y mejorar la eficiencia de las consultas realizadas a una tabla determinada. Estos índices contienen copias de los datos de la tabla, organizados con una estructura B-árbol que permite a SQLSERVER encontrar las filas asociadas a los valores de clave rápida y eficientemente. Al ejecutar una consulta, el optimizador de consultas se encarga de evaluar cada método disponible para recuperar los datos. Luego, selecciona al mas eficiente. Es decir, aquel que minimice el uso de recursos y tiempo.



## Estructura de los índices

Ahondando en la estructura de los índices, un B-árbol es una estructura auto-balanceada capaz de organizar las copias de los datos de la tabla en diferentes nodos lógicos, facilitando y optimizando las operaciones de búsqueda. 

Los nodos de un B-árbol se dividen en diferentes categorías o niveles:

* Nodo raíz: nivel superior del árbol. Se considera como el punto de partida de cualquier búsqueda. Posee los rangos de claves y punteros a los nodos del siguiente nivel.
* Nodos intermedios: aquellos que contienen rangos de claves y punteros a los nodos de nivel inmediatamente inferior.
* Nodos hoja: en ellos se almacena la información real delas claves del índice. Estos nodos se encuentran enlazados secuencialmente, permitiendo exploraciones eficientes.



## Tipos de índices:

Los índices se pueden dividir en dos tipos principales.

* Clustered: determina el orden físico de almacenamiento de los datos en la tabla. Únicamente existe uno por tabla. Los nodos hoja de este tipo de índice contienen datos completos de la tabla.
* Nonclustered: es una estructura que contiene las claves seleccionadas y un puntero a la ubicación real de los datos. Es posible tener múltiples índices nonclustered por tabla. Sus nodos hojas contienen unicamente las claves del índice y punteros a la fila de datos.



## Conclusiones sobre el tema

Los índices se encargan de permitir que motor de la base de datos realice una búsqueda rápida y directa de datos. 
El optimizador de consultas tiene un rol central al utilizar los índices. Selecciona el plan de ejecución más eficiente basándose en los índices disponibles, garantizando el menor costo posible de recursos y tiempo de respuesta por consulta.
Si bien los índices mejoran considerablemente las operaciones de lectura, también añaden una sobrecarga al sistema durante las operaciones de escritura. Esto se debe a que el motor debe mantener y actualizar las estructuras del índice.
Considerando todo lo anteriormente mencionado, se puede concluir en que es indispensable utilizar una buena estrategia de indexación si se espera mantener un alto rendimiento y una experiencia de usuario óptima. 

