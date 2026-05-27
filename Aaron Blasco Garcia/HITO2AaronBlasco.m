%%%%%%%%%%%%%%%%%%%
clear,clc,close all

%%%%%%%%% HITO 2 Camino Minimo Rover %%%%%%%%
load("VariablesHito1.mat")
% Cargamos las variables a usar del anterio Hito 
figure();
p  = plot(G);
p.XData = X_Nuevo; % Asignar coordenadas X a los nodos
p.YData = -Y_Nuevo; % Asignar coordenadas Y a los nodos
p.NodeColor = coloresNodos; % Asignnar colores a los nodos
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
%%%%%%%%%%%% Ya tenemos el grafo del anterior Hito %%%%%%

% Apartado a -> Superposcion del grafo
figure;
imshow(img);
hold on; % Mantenemos la imagen 
p  = plot(G);

% Mostramos el grafo correctamente
p.XData = X_Nuevo; % Asignar coordenadas X a los nodos
p.YData = Y_Nuevo; % Asignar coordenadas Y a los nodos
% No lo invertimos ya que la imagen se muetra con Imshow y no hace falta
p.NodeColor = coloresNodos; % Asignnar colores a los nodos
p.EdgeAlpha = 0.2; % líneas transparentes
p.LineWidth = 0.3; % Aumentar el grosor de los Ejes
p.MarkerSize = 1; % Ajustar el tamaño de los nodos
hold off

% Apartado b -> Crear el camino minimo
% Ponemos las coordenas de el incio y final para hacer el camino minimo
Inicio  = '81-369'; % Nodo inicial
Final = '961-721'; % Nodo final
path = shortestpath(G,Inicio,Final);
% Vamos a conseguir el tiempo
% Calcular el tiempo para recorrer el camino mínimo
   Tiempo = 0;
for i = 1:length(path)-1
    nodoOrigen  = path(i); % Asignamos el nodo origen
    nodoDestino = path(i+1); % Asignamos el nodo destino
    idx = findedge(G, nodoOrigen, nodoDestino); % Buscamo el eje con esos nodos
    Tiempo = Tiempo + G.Edges.Weight(idx); % Buscamaos el peso de ese eje
end
fprintf("El tiempo necesario desde 81-369 hasta 961-721 es de: %8.3f \n",Tiempo)

% Apartado c -> Mostrar el camino minimo
pathNuevo = [];
for i = 1 : length(path)-1
    if i ~= 1 % No añadimos el inicio y el final por que sera dibujado aparte
        pathNuevo = [pathNuevo,path(i)];
    end
end
figure();
imshow(img);
hold on; % Mantenemos la imagen
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
% Resaltar el camino mínimo en el grafo
highlight(p, pathNuevo,"NodeColor",'red',"MarkerSize",2,"EdgeColor","red")
hold off
