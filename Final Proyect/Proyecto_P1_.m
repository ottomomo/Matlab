%
% INSTITUTO TECNOLOGICO Y DE ESTUDIOS SUPERIORES DE MONTERREY
% Campus Ciudad de Mexico
%
% Robot Vision
% TC3050.1
%
% Equipo 4
% Proyecto 1
%
clc
clear all
close all
threshold = 64;%Partiendo del optimal threshold del metodo de OTSU (106)
rgb = imread('bucks_and_cents_[EQUIPO_4].png');%Lee y guarda la imagen a procesar
grayimage=rgb2gray(rgb);%Crea una imagen en escala de grises 
[pixelCount,grayLevels] = imhist(grayimage);
g = grayimage > threshold; %Crea la imagen binaria dependiendo del threshold
imgMIN=zeros(707,705);%jojo
imgMAX=zeros(707,705);%jojo
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Show Images%%%%%%%%%%%%%%%%%%
figure('Name','Images and Histogram','NumberTitle','off');%Nombre de la figura
subplot(2, 2, 1);
imshow(rgb); %Despliega la imagen original a color
title('Original RGB Image.','fontsize',9); %Titulo de la imagen

subplot(2, 2, 2);
imshow(grayimage); %Despliega la imagen en escala de grises
title('Grayscale Image.','fontsize',9);%Titulo de la imagen


subplot(2, 2, 3);
imshow(g); %Despliega la imagen binaria
title(['Segmented Image considering a Threshold of ' num2str(threshold) ' .'],'fontsize',9); %Titulo de la imagen

subplot(2, 2, 4);
bar(pixelCount); %Crea el histograma
grid on; %Activa el cuadricula
title('Histogram of ScaleGray Image', 'FontSize', 9);%Titulo 
xlabel('gray levels') %Titulo de eje x
ylabel('frequency') %Titulo de eje y
hold on 
x=[threshold,threshold];
y=[0,20000];
plot(x,y)%Crea una linea vertical donde esta el threshold
txt1 = '\leftarrowThreshold at 64 graylevels';%Señala el threshold
text(65,10000,txt1, 'Color', 'b','FontSize', 8);
txt1 = 'Foreground'; 
text(120,17500,txt1, 'Color', 'm','FontSize', 8);%señala el foreground
txt1 = 'Background';
text(2,17500,txt1, 'Color', 'm','FontSize', 8);%Señala background
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Label%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[L,n] = bwlabel(g);% Etiqueta regiones en una foto y los conecta en una imagen 2D
labelRGB = label2rgb(L);% Convierte el etiquetado en una imagen RGB
labels=regionprops(L);% Dar algunas propiedades de las regiones etiquetadas
area=[]; %Genera arreglos 
centroid=[];
rect=[];
perimetro=[];
diametro=[];
p=1;%Inicializa p a 1 para poder recorrer el arreglo
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Filtro%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:n
    if(labels(i).Area>6)
        area(p,1)=labels(i).Area; %Guarda las estructuras seleccionadas en arreglos para una mejor organiación
        centroide(p,1)=labels(i).Centroid(1);
        centroide(p,2)=labels(i).Centroid(2);
        rect(p,1)=labels(i).BoundingBox(1);
        rect(p,2)=labels(i).BoundingBox(2);
        rect(p,3)=labels(i).BoundingBox(3);
        rect(p,4)=labels(i).BoundingBox(4);
        p=p+1;
    end
end 
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Results and Extra%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:10
    diametro(i,1)=2*sqrt(area(i)/pi());%reccore el arreglo para despejar el diametro del area
    perimetro(i,1)=pi()*diametro(i,1);% Partiendo del area, se calculó el perimetro
end
%jojo alan 
suma=0;
contador=0;
for m=1:10
    radio=diametro(m)/2;
    for yi=1:707
        for xi=1:705
            distancia=sqrt((yi-centroide(m,2))^2+(xi-centroide(m,1))^2);
            if(distancia<=radio)
                suma=suma+double(grayimage(yi,xi));
                contador=contador+1;
                if(radio<60)%Moneda pequeña
                    imgMAX(yi,xi)=1;
                else 
                    imgMIN(yi,xi)=1;
                end         
            end
        end
    end
    promedio(m)=suma/contador;
end 

resultado=cat(2,area,diametro,perimetro,centroide,promedio'); %concatena todos los arreglos en un solo arreglo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Figueres%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','Label','NumberTitle','off');%Titulo de la figura
subplot(1, 2, 1);
imshow(g);%Vuelve a mostrar la imagen 
title('Binary Image.','fontsize',9);%titulo de la imagen 
hold on 
for i=1:10
    txt1 = num2str(i);
    text(round(centroide(i,1)),round(centroide(i,2)),txt1, 'Color', 'm','FontSize', 7);%Poner el numero en el centro de cada moneda
end

subplot(1, 2, 2);
imshow(labelRGB);%Muestra la imagen RGB
title('Color Labled Image','fontsize',9);%titulo de la imagen 
hold on 
for i=1:10
    rectangle('Position',[rect(i,1),rect(i,2),rect(i,3),rect(i,4)],'EdgeColor','r');%Grafica los rectangulos eb cada circulo
end


figure('Name','Table of Results','NumberTitle','off');%nuevo nombre de la figura
%t = array2table(resultado,'VariableNames',{'Coin','Area','Diameter','Perimeter','CentroideY','CentroideX','Intensity'});
t = uitable('Data',resultado,'Position',[50 100 495 205]);%crea una tabla 
t.ColumnName={'Area','Diameter','Perimeter','CentroideY','CentroideX','Intensity'};%asignas los nombres de los columnas
titulo = uicontrol('Style', 'text', 'Position', [30 310 200 20], 'String', 'Results', 'FontSize', 10, 'FontWeight', 'bold');
%Genera un título para la tabla
figure('Name','Extra','NumberTitle','off');% Genera una nueva figura
subplot(1, 2, 1);
imshow(imgMAX);%Muestra la imagen 
title('Small Coins','fontsize',9);

subplot(1, 2, 2);
imshow(imgMIN);%Muestra la imagen 
title('Big Coins','fontsize',9);


