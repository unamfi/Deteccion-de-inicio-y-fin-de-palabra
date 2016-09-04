%% Desarrollo

%% 1
fid = fopen('3an.raw','r'); % Se abre la se�al
x = fread(fid,inf,'int16');

lenX = length(x); % Se obtiene el tama�o de la se�al, indispensable para usos futuros

n = 128; % N�mero de muestras por ventana
M = n;
nV = lenX/n; % N�mero de ventanas

% Segmentaci�n de la se�al
for i=0:1:nV-1
    xTramada{i+1} = x(i*n+1:(i+1)*n);
end

%Energ�a en tiempo corto
Ex = [];
for i=1:1:nV
    Ex = [Ex sum((abs(xTramada{i})).^2)];
end

%Magnitud en tiempo corto
Mx = [];
for i=1:1:nV
    Mx = [Mx sum(abs(xTramada{i}))];
end

%Cruces por cero
Zx = [];
for i=1:1:nV
    
    Zxi = 0;

    for j=1:1:n-1
        Zxi = Zxi + abs(sign(xTramada{i}(j+1))-sign(xTramada{i}(j)));
    end

    Zxi = Zxi/(2*n);
    
    Zx = [Zx Zxi];

end

% Graficaci�n del punto 1
figure('name','Se�al 1');
subplot(131);
plot(Ex);
title('Energ�a en tiempo corto');
subplot(132);
plot(Mx);
title('Magnitud en tiempo corto');
subplot(133);
plot(Zx);
title('Cruces por cero');
pause;
close;

%% 3

% Graficaci�n del punto 2
figure('name','Se�al 1');
subplot(131);
plot(Mx);
title('Magnitud en tiempo corto');
subplot(132);
plot(Zx);
title('Cruces por cero');
subplot(133);
plot(x);
title('Se�al en tiempo');
pause;
close;

%% 4

% Primeras 10 tramas de ruido
Ms = Mx(1:10);
Zs = Zx(1:10);

% C�lculo de umbrales
UmbSupEnrg = 0.5*max(Mx);
UmbInfEnrg = median(Ms) + (2*std(Ms));
UmbCruCero = median(Zs) + (2*std(Zs));

display(2*std(Zs));

% Graficaci�n de las l�neas horizontales del punto 4
lineaUmbSupE = UmbSupEnrg*ones(nV);
lineaUmbInfE = UmbInfEnrg*ones(nV);
lineaUmbCruC = UmbCruCero*ones(nV);

figure('name','Se�al 1');
subplot(131);
plot(Mx);
hold;
plot(lineaUmbSupE,'r');
plot(lineaUmbInfE,'g');
hold;
title('Magnitud en tiempo corto');
subplot(132);
plot(Zx);
hold;
plot(lineaUmbCruC, 'r');
hold;
title('Cruces por cero');
subplot(133);
plot(x);
title('Se�al en tiempo');
pause;
close;

%% 5 

% C�lculo de ln
ln = 0;

for n = 11:1:nV
    if(Mx(n)>=UmbSupEnrg)
        ln=n;
        break
    end
end

display(ln);

% C�lculo de le
le = 0;

for n = ln:-1:0
    if(Mx(n)<=UmbInfEnrg)
        le = n;
        break
    end
end

% C�lculo de le para el fin de palabra
lef = nV;

for n = ln:1:nV
    if(Mx(n)<=UmbInfEnrg)
        lef=n;
        break
    end
end

display(le);
display(lef);

% C�lculo de lz
lz = le;

vecesMenorA0 = 0;

for n = lef:1:nV
    if(Zx(n)<UmbCruCero)
        vecesMenorA0 = vecesMenorA0+1;
    end
end

if(vecesMenorA0 < nV)
    cont = 0;

    for n = le:-1:11
        if(Zx(n)>UmbCruCero)
            cont = cont+1;
            if(cont >= 3)
                lz=n;
            end
        else
            cont = 0;
        end
    end
end

% C�lculo de lz para el fin de palabra
lzf = lef;

vecesMenorA0 = 0;

for n = lef:1:nV
    if(Zx(n)<UmbCruCero)
        vecesMenorA0 = vecesMenorA0+1;
    end
end

if(vecesMenorA0 < nV)
    cont = 0;

    for n = lef:1:nV
        if(Zx(n)>UmbCruCero)
            cont = cont+1;
            if(cont >= 3)
                lzf=n;
            end
        else
            cont = 0;
        end
    end
end

display(lz)
display(lzf)

% Graficaci�n de l�neas horizontales del punto 5
figure('name','Se�al 1');
subplot(131);
plot(Mx);
hold;
plot(lineaUmbSupE,'r');
plot(lineaUmbInfE,'g');
a=[lz,lz];
y=[0,max(Mx)];
plot(a,y,'m')
a=[lzf,lzf];
y=[0,max(Mx)];
plot(a,y,'m')
a=[le,le];
y=[0,max(Mx)];
plot(a,y,'m')
a=[lef,lef];
y=[0,max(Mx)];
plot(a,y,'m')
a=[ln,ln];
y=[0,max(Mx)];
plot(a,y,'m')
hold;
title('Magnitud en tiempo corto');
subplot(132);
plot(Zx);
hold;
plot(lineaUmbCruC, 'r');
a=[lz,lz];
y=[0,max(Zx)];
plot(a,y,'m')
a=[lzf,lzf];
y=[0,max(Zx)];
plot(a,y,'m')
a=[le,le];
y=[0,max(Zx)];
plot(a,y,'m')
a=[lef,lef];
y=[0,max(Zx)];
plot(a,y,'m')
a=[ln,ln];
y=[0,max(Zx)];
plot(a,y,'m')
hold;
title('Cruces por cero');
subplot(133);
plot(x);
title('Se�al en tiempo');
pause;
close;

%% Grafica de Se�al original y recortada

xRecortada = x((lz-1)*M:lzf*M);

figure('name','Se�al Original y recortada')
subplot(121);
plot(x);
title('Se�al original')
subplot(122);
plot(xRecortada);
title('Se�al recortada')
pause;
soundsc(x,11025);
pause;
soundsc(xRecortada,11025);
pause;
close all;

clear all;