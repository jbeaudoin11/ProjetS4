clc 
clear all
close all

% ---------------------------------Constantes--------------------------------------- 

% Quantités physiques
masseP = 425; % Masse de la plaque ±10 g
inertiePx = 1169.1; % ±0.2 kg*mm²
inertiePy = 1169.1; % ±0.2 kg*mm²
masseS = 8.0; % Masse de la sphère ±0.2 g
rs = 3.9; % Rayon de la sphère ±0.1 mm
Rabc = 3.6; % Résistance des actionneurs +1.0 -0.5 ohms 
Labc = 115; % Inductance des actionneurs +15 -10 mH
Vmax = 22; % Voltage maximal des actionneurs (en absolue)

% Rayons
rabc = 95.2; % Actionneurs en mm
rdef = 80.0; % Capteurs en mm

% Coordonnées inertielles des actionneurs

% Actionneur A
XA = rabc;
YA = 0;
ZA = 0;

% Actionneur B
XB = -rabc*sin(30);
YB = rabc*cos(30);
ZB = 0;

% Actionneur C
XC = -rabc*sin(30);
YC = -rabc*cos(30);
ZC = 0;

% Coordonnées inertielles des capteurs

% Capteur D
XD = rdef*sin(30);
YD = rdef*cos(30);
ZD = 0;

% Capteur E
XE = -rdef;
YE = 0;
ZE = 0;

% Capteur F
XF = rdef*sin(30);
YF = -rdef*cos(30);
ZF = 0;

% ---------------------------------Variables d'états--------------------------------------- 
x = [x1' x2' x3' x4' x5' x6' x7' x8' x9' x10' x11' x12' x13']'; % À modifier pour la nomenclature 

% ---------------------------------Hauteur Zk des actionneurs------------------------------
za = z - XA*Ay + YA*Ax;
zb = z - XB*Ay + YB*Ax;
zc = z - XC*Ay + YC*Ax;

%---------------------------------Force Fk des actionneurs--------------------------------- 
Fa = ((((IA^2)+be1*abs(IA))*sgn(IA))/(ae0+(ae1*za)+(ae2*(za.^2))+(ae3*(za.^3)))) - 1/(as0+(as1*za)+(as2*(za.^2))+(as3*(za.^3))); 
Fb = ((((IB^2)+be1*abs(IB))*sgn(IB))/(ae0+(ae1*zb)+(ae2*(zb.^2))+(ae3*(zb.^3)))) - 1/(as0+(as1*zb)+(as2*(zb.^2))+(as3*(zb.^3)));
Fc = ((((IC^2)+be1*abs(IC))*sgn(IC))/(ae0+(ae1*zc)+(ae2*(zc.^2))+(ae3*(zc.^3)))) - 1/(as0+(as1*zc)+(as2*(zc.^2))+(as3*(zc.^3)));
