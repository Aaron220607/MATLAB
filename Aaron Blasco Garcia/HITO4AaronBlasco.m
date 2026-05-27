%%%%%%%%%%%%%%%%%%%
clear,clc,close all

% Cargamos las variables que vamos a utilizar en este hito
% Junto con los puntos de interes
load("VariablesHito3.mat")
load("points_of_interest.mat")
% Apartafo A -> Creacion de Greduced
% Se nos pide crear un nuevo grafo cuyos vertices sean los puntos de
% interes y sus aristas sean el tiempo de su camino minimo
G; % Cargamos el grafo
Greduced = graph();
for i = 1 :length(points_of_interest)
    for j = i+1:length(points_of_interest)
        CaminoPuntosIteres = shortestpath(G,puntosInteres(i),puntosInteres(j));
          Tiempo =0;
            for k = 1:length(CaminoPuntosIteres)-1
                nodoOrigen  = CaminoPuntosIteres(k); % Asignamos el nodo origen
                nodoDestino = CaminoPuntosIteres(k+1); % Asignamos el nodo destino
                idx = findedge(G, nodoOrigen, nodoDestino); % Buscamo el eje con esos nodos
                Tiempo = Tiempo + G.Edges.Weight(idx);
            end
        Greduced = addedge(Greduced,puntosInteres(i),puntosInteres(j),Tiempo);
    end
end

% Apartado b -> Mostrar el grafo Greduced
figure();
imshow(img);
hold on;
p = plot(G);
p.XData = X_Nuevo;
p.YData = Y_Nuevo;
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
p.EdgeAlpha = 0;
p2  = plot(Greduced);
% Ejes del grafo
X_Reduced = [];
Y_Reduced = [];
for i = 1:length(puntosInteres)
    idx = findnode(G, puntosInteres(i));
    X_Reduced(i) = X_Nuevo(idx);
    Y_Reduced(i) = Y_Nuevo(idx);  
end
p2.XData = X_Reduced;
p2.YData = Y_Reduced;
% No lo invertimos ya que la imagen se muetra con Imshow y no hace falta
p2.EdgeAlpha = 0.5; % líneas transparentes
p2.EdgeColor = "white";
p2.MarkerSize = 4; % Ajustar el tamaño de los nodos
p2.NodeColor = "black";
hold off
% Apartado C -> Arbol Minimo Generador
arbolGreduced = minspantree(Greduced);
% Mostramos por pantalla en tiempo del Arbol
TiempoArbol = sum(arbolGreduced.Edges.Weight);
fprintf("El tiempo total del arbol es de: %8.3f \n",TiempoArbol)
% Ahora pasaremos a mostrar el grafo de nuevo, es decir, mostrare el grafo
% ya antes mostrado y ahora resaltare el arbol
figure();
imshow(img);
hold on;
p = plot(G);
p.XData = X_Nuevo;
p.YData = Y_Nuevo;
p.MarkerSize = 0.5;
p.EdgeAlpha = 0;
p2  = plot(Greduced);
p2.XData = X_Reduced;
p2.YData = Y_Reduced;
% No lo invertimos ya que la imagen se muetra con Imshow y no hace falta
p2.EdgeAlpha = 0.5; % líneas transparentes
p2.EdgeColor = "white";
p2.MarkerSize = 4; % Ajustar el tamaño de los nodos
p2.NodeColor = "black";
highlight(p2,arbolGreduced,"EdgeColor","cyan","LineWidth",5)
hold off