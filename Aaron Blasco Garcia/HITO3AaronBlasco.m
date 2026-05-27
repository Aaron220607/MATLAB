%%%%%%%%%%%%%%%%%%%
clear,clc,close all

% Cargamos la variables del hito anterior
load("VariablesHito2.mat")
% Cargamos los puntos de interes dados en la pratica
load("points_of_interest.mat")
% Apartado a -> Resaltar los puntos de interes
% Para ellos con el grafo anterio y el mismo diseño del hito 2
% añadiremos un nuevo resaltado de estos puntos de interes
puntosInteres = string();
for i=1 :length(points_of_interest)
    puntosInteres(i) = string(points_of_interest(i,1)) + "-" + string(points_of_interest(i,2)); 
end
figure();
imshow(img);
hold on;
p  = plot(G);

% Mostramos el grafo correctamente
p.XData = X_Nuevo; % Asignar coordenadas X a los nodos
p.YData = Y_Nuevo; % Asignar coordenadas Y a los nodos
% No lo invertimos ya que la imagen se muetra con Imshow y no hace falta
p.NodeColor = coloresNodos; % Asignnar colores a los nodos
p.EdgeAlpha = 0.2; % líneas transparentes
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
highlight(p,Inicio,"NodeColor","green","MarkerSize",4)
highlight(p,Final,"NodeColor","blue","MarkerSize",4)
highlight(p, pathNuevo,"NodeColor",'red',"MarkerSize",2)
highlight(p,puntosInteres,'NodeColor', [0.5 0.5 0.5],'MarkerSize',4,'Marker','o')
hold off

% Apartado b -> Mostrar los puntos de interes visibles
figure();
imshow(img);
hold on;
p  = plot(G);

% Mostramos el grafo correctamente
p.XData = X_Nuevo; % Asignar coordenadas X a los nodos
p.YData = Y_Nuevo; % Asignar coordenadas Y a los nodos
% No lo invertimos ya que la imagen se muetra con Imshow y no hace falta
p.NodeColor = coloresNodos; % Asignnar colores a los nodos
p.EdgeAlpha = 0.2; % líneas transparentes
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
highlight(p,Inicio,"NodeColor","green","MarkerSize",4)
highlight(p,Final,"NodeColor","blue","MarkerSize",4)
highlight(p, pathNuevo,"NodeColor",'red',"MarkerSize",2)
highlight(p,puntosInteres,'NodeColor', [0.5 0.5 0.5],'MarkerSize',4,'Marker','o')
hold off
% Pasaremos ver cuales son los puntos visibles
area = 128; % Distancia de pixeles Minima para observar
% Recorreremos el camino y veremos la distacia de cualquier punto a ese
% punto del camino
puntosInteresVisitados = [];
for i=1 : length(path)
    idNodo = findnode(G,path(i)); 
    % Con la funcion de findnode obtenemos el id del nodo del camino
    CoordenadasX = X_Nuevo(idNodo); % Obtenemos coordenadas de X
    CoordenadasY = Y_Nuevo(idNodo); % Obtenemos coordenadas de Y
    for j=1: length(points_of_interest)
        % Obtenemos la distancia de los puntos de interes y el nodo del
        % camino minimo 
        distancia = sqrt(((points_of_interest(j,2)-CoordenadasX)^2) + (points_of_interest(j,1)-CoordenadasY)^2);
        % Comparamos la distancia del nodo del camino con la de el punto de
        % interes primero luego la del segundo y asi sucesivamente
        if(distancia<=area)
            % Ponemos de color verde si nuestro rover es capaz de ver ese
            % punto
            highlight(p,puntosInteres(j),'NodeColor','green');
            puntosInteresVisitados = [puntosInteresVisitados puntosInteres(j)];
        end
    end
end
puntosInteresVisitados = unique(puntosInteresVisitados);
puntosVibles = length(puntosInteresVisitados);
% Mostramos el numero total
fprintf("Puntos de interes observables: %d\n", puntosVibles);

% Mostramos cada punto en una linea con un bucle
fprintf("Los puntos observados son:\n");
for i = 1 : length(puntosInteresVisitados)
    fprintf("%s\n", puntosInteresVisitados(i));
end