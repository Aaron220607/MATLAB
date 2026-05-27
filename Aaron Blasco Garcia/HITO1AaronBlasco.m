%%%%%%%%%%%%%%%%%%%
clear,clc,close all


%%%%%%%%% HITO 1 Construcción del grafo de navegación del rover %%%%%%%%5
% Apartado a -> Cargar la imagen dada en el fichero
img = imread("Terreno_1.png"); % Almacenamos la imagen en una variable
% img Almacena una matriz
figure();
imshow(img);% Mostramos la variable
title("Terreno Marciano");
% Apartado b -> Cargar la mascara de terreno
figure();
M = imread("Terreno_1_mask.png");
imshow(M)
% Construccion de la nueva Matriz T
[filas,columnas,z] = size(M); 
% con la funcion size obtenemos las filas y la columnas
%  vamos a crear una nueva matriz T que en funcion del tono de gris
%  almacene una constante
T = [];
for i = 1:filas
    for j =1:columnas
        if(M(i,j)<45)
            T(i,j)=0;  % 0 : roca compacta (zona intransitable)
        elseif (M(i,j)>=45 && M(i,j)<135)
            T(i,j) = 1; % 1 : regolito firme
        elseif (M(i,j)>=135 && M(i,j)<225)
            T(i,j) = 2; % 2 : duna blanda
        else 
            T(i,j) = 3; % 3 : duna profunda
        end
    end
end
% Apartado C -> Mostrar la Matriz T con un diseño especifico
% Mostraremos la imagen con imagesc
imagesc(T)
% creamos un colobar, cuya estructura es una imagen
% igual que en otras practicas hechas, por medio de la estrutura de
% NombreVariable. podremos modificar la representacion de la imagen
colormap(terrainColors()) % Añadimos los colores con la funcion colormap
% Junto a la matriz de colores que nos da la funcion de terrainColors
cb = colorbar;
% Ponemos los valores de nuesta matriz
cb.Ticks = [0 1 2 3];
% Anadimos una etiqueta a aquellos colores y que representan
cb.TickLabels = {'Roca compacta','Regolito firme','Duna blanda','Duna profunda'};
% Apartado d -> Cronstruccion del grafo
% Constentes para la creacion del grafo
pixels = 16; 
gsd = 0.5;
[filas, columnas] = size(T);
%  Creamos un grafo vacio inicialmente 
G = graph();
% Recorremos toda la matriz y comprobamos si existe conexion en cuatro
%%%%%% Posibles caso %%%%%%%
% Nodo de la derecha
% Nodo Abajo
% Nodo Diagonal Izquierda Y Derecha
for i = 1:pixels:filas
    for j = 1:pixels:columnas
        % Guardeamos el posible nodo
            nombre_actual = string(i) + "-" + string(j);
            %  DERECHA
            columnaDerecha = j + pixels; % sumamos los pixeles para tener el de la derecha
            if columnaDerecha<= columnas 
                % Guardamos el nodo de su derecha
                nombreDerecha = string(i) + "-" + string(columnaDerecha);
                % Calculamos su velocidad por medio de la funcion dada
                vel = computeSpeed([i j], [i columnaDerecha], T);
                if vel > 0 % Verificamos si se puede dar el nodo
                    tiempo = (pixels * gsd) / vel;
                    G = addedge(G, nombre_actual, nombreDerecha, tiempo);
                end
            end

            % ABAJO
            filaAbajo = i + pixels; % A la fila le sumamos los pixeles para ir a la fila de abajo
            if filaAbajo <= filas 
                % Guardamos el nodo de abajo
                nombreAbajo = string(filaAbajo) + "-" + string(j);
                vel = computeSpeed([i j], [filaAbajo j], T);
                if vel > 0
                    tiempo = (pixels * gsd) / vel;
                    G = addedge(G, nombre_actual, nombreAbajo, tiempo);
                end
            end

            % DIAGONAL DERECHA
            filaAbajo = i + pixels; columnaDerecha = j + pixels;
            % Sumamos pixels para bajar y para ir a la derecha
            if filaAbajo <= filas && columnaDerecha <= columnas 
                % Guardamos el nodo de su diagonal derecha
                nombreDiaDerecha = string(filaAbajo) + "-" + string(columnaDerecha);
                vel = computeSpeed([i j], [filaAbajo columnaDerecha], T);
                if vel > 0
                    tiempo = (pixels * sqrt(2) * gsd) / vel;
                    % raiz de 2 ya que la altura es 16 la base es 16 
                    G = addedge(G, nombre_actual,  nombreDiaDerecha , tiempo);
                end
            end

            %  DIAGONAL IZQUIERDA
            filaAbajo = i + pixels; columnaIzquierda = j - pixels;
            % Sumamos pixeles para ir abajo y restamos para ir a la
            % izquierda
            if filaAbajo <= filas && columnaIzquierda >= 1 
                % Guardamos el nodo de su diagonal Izquierda
                nombreDiaIzquierda = string(filaAbajo) + "-" + string(columnaIzquierda);
                vel = computeSpeed([i j], [filaAbajo columnaIzquierda], T);
                if vel > 0
                    tiempo = (pixels * sqrt(2) * gsd) / vel;
                     % raiz de 2 ya que la altura es 16 la base es 16 
                    G = addedge(G, nombre_actual,  nombreDiaIzquierda , tiempo);
                end
            end
     end
 end

% Buscamos aquellos nodos no tiene ningun eje 
% NOTA: Estos son por ejemplo los nodos que hacen referencia a las rocas
nodos_aislados = find(degree(G)==0);
G = rmnode(G, nodos_aislados);
% Vamos a guardar el nombre de todos los nombres posibles
nombres = strings();
X = []; % Coordenas X
Y = []; % Coordenas Y
contador = 0; % Variable auxiliar

for i = 1:pixels:filas
    for j = 1:pixels:columnas
        if T(i,j) ~= 0
            contador = contador + 1;
            nombres(contador) = string(i) + "-" + string(j);
            % Guardamos las coordenas de todos los nodos posibles
            X(contador) = j; 
            Y(contador) = i;
        end
    end
end
% Como hemos eliminado ciertos nodos debemos reajustar la imagen del grafo
%  Para ello veremos que nodos quedan en el grafo y guardaremos sus
%  posiciones
nodosRestantes = G.Nodes.Name;
X_Nuevo = [];
Y_Nuevo = [];
% Recorremos todos los nodos del grafo con todos los posibles que habia
for k = 1:length(nodosRestantes)
    for m = 1:length(X) 
        if nodosRestantes{k} == nombres(m)
            % Si Coinciden Extraeremos sus cordenadas y la pondremos en el
            % nuevo vector
            X_Nuevo(k) = X(m);
            Y_Nuevo(k) = Y(m);
        end
    end
end
% Buscamos estos nodos y Guardamos sus cordenadas para hacer el dibujo mejor

% Apartado e -> Visualizacion del Grafo
figure();
p = plot(G);
% Asignamos la matriz que devueleve la funcio terrainColors
coloresRGB = terrainColors;
coloresNodos = [];
for i= 1: numnodes(G)
 tipoTerrenos  = T(Y_Nuevo(i),X_Nuevo(i));
 coloresNodos(i,:) = coloresRGB(tipoTerrenos +1 , :); 
 % Asignamos el color segun  el tipo de terreno
 % Añadimos un +1 ya que tipoTerrenos devuelveun valor de 0-3
 % Y para selecionar la fila correspondiente necesitamos un valor de 1-4
 % Por lo que debemos aumentar una unidad
end
p.XData = X_Nuevo; % Asignar coordenadas X a los nodos
p.YData = -Y_Nuevo; % Asignar coordenadas Y a los nodos
p.NodeColor = coloresNodos; % Asignnar colores a los nodos
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
