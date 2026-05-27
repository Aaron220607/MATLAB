function v = computeSpeed(pos_v1, pos_v2, T)
% Calcula la velocidad media entre dos vértices
% pos_v1, pos_v2 = [row, col]
% T = matriz de tiplogía del terreno

% Velocidades por tipo de terreno: roca, regolito firme, duna blanda, duna profunda
vel = [0, 1.0, 0.6, 0.3];

r1 = pos_v1(1);
c1 = pos_v1(2);

r2 = pos_v2(1);
c2 = pos_v2(2);

% Obtener los píxeles del trayecto
if r1 == r2
    % Movimiento horizontal
    cols = min(c1,c2):max(c1,c2);
    rows = r1 * ones(size(cols));

elseif c1 == c2
    % Movimiento vertical
    rows = min(r1,r2):max(r1,r2);
    cols = c1 * ones(size(rows));

elseif abs(r2 - r1) == abs(c2 - c1)
    % Movimiento diagonal
    rows = round(linspace(r1, r2, abs(r2-r1)+1));
    cols = round(linspace(c1, c2, abs(c2-c1)+1));

else
    error("Movimiento no permitido");
end

% Tipos de terreno
tipos = T(sub2ind(size(T), rows, cols));

% Si hay roca no se puede pasar
if any(tipos == 0)
    v = 0;
    return;
end

% Velocidad media
velocidades = vel(tipos + 1);
v = mean(velocidades);

end