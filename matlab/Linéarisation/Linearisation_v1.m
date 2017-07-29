clear all
close all
clc

commandwindow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    Linéarisation des équations d'états et sortie
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Premier auteur : Pascal Lemieux
%Date de création : 2017-06-07
% 
%Version : 1.0
%
%Révision : #VER // DATE // #NOM
%
%




%% initialisation des constante


%bancEssaiConstantes



%constantes
syms RR LL RA LA RB LB RC LC Jxy mP mS rS JS g
syms XA YA ZA XB YB ZB XC YC ZC
syms XD YD ZD XE YE ZE XF YF ZF


%Matrices liaisons
%ABC
xvec_ABC = [XA, XB, XC]';
yvec_ABC = [YA, YB, YC]';

TABC = [yvec_ABC'; -xvec_ABC'; ones(1,3)];
TABC_inv = inv(TABC);

%DEF
xvec_DEF = [XD, XE, XF]';
yvec_DEF = [YD, YE, YF]';

TDEF = [yvec_DEF'; -xvec_DEF'; ones(1,3)];
TDEF_inv = inv(TDEF);


%états
syms Ax Ay Pz Wx Wy Vz Px Py Vx Vy IA IB IC 
%d(états)
syms dAx dAy dPz dWx dWy dVz dPx dPy dVx dVy dIA dIB dIC 
%entrées
syms VA VB VC
%sorties
syms zA zB zC zD zE zF Px_mes Py_mes Vx_mes Vy_mes

X = [Ax; Ay; Pz; Wx; Wy; Vz; Px; Py; Vx; Vy; IA; IB; IC];
dX = [dAx; dAy; dPz; dWx; dWy; dVz; dPx; dPy; dVx; dVy; dIA; dIB; dIC];

U = [VA; VB; VC];

Y = [zD; zE; zF; Px; Py; Vx; Vy];


syms aE0 aE1 aE2 aE3 aS0 aS1 aS2 aS3 bE1 

signI = -1;

zA = Pz - XA*Ay + YA*Ax; 
zB = Pz - XA*Ay + YA*Ax; 
zC = Pz - XA*Ay + YA*Ax; 

FEA = (signI*IA^2 + bE1*IA)/(aE0 + aE1*zA + aE2*zA^2 + aE3*zA^3);
FEB = (signI*IB^2 + bE1*IB)/(aE0 + aE1*zB + aE2*zB^2 + aE3*zB^3);
FEC = (signI*IC^2 + bE1*IC)/(aE0 + aE1*zC + aE2*zC^2 + aE3*zC^3);

FSA = -1/(aS0 + aS1*zA + aS2*zA^2 + aS3*zA^3);
FSB = -1/(aS0 + aS1*zB + aS2*zB^2 + aS3*zB^3);
FSC = -1/(aS0 + aS1*zC + aS2*zC^2 + aS3*zC^3);

FA = FEA + FSA;
FB = FEB + FSB;
FC = FEC + FSC;

%équations d'états
% dx{i} = d(x_i)/dt

dx{1} = Wx;
dx{2} = Wy;
dx{3} = Vz;
dx{4} = 1/Jxy*(FA*YA + FB*YB + FC*YC + mS*g*Py);
dx{5} = -1/Jxy*(FA*XA + FB*XB + FC*XC + mS*g*Px);
dx{6} = (FA + FB + FC)/(mP + mS) + g;
dx{7} = Vx;
dx{8} = Vy;
dx{9} = -5*g/7 * Ay;
dx{10} = 5*g/7 * Ax;
dx{11} = VA/LA - RR/LA * IA;
dx{12} = VB/LB - RR/LB * IB; 
dx{13} = VC/LC - RR/LC * IC; 

y{1} = Pz - XD*Ay + YD*Ax; 
y{2} = Pz - XE*Ay + YE*Ax; 
y{3} = Pz - XF*Ay + YF*Ax;  
y{4} = Px;
y{5} = Py;
y{6} = Vx;
y{7} = Vy;


%% Détermination de la matrice A
for i = 1:13
    for j = 1:13      
        A(i,j) = diff(dx{i},X(j));            
    end
end

disp('Matrice A');pretty(A)

%% Détermination de la matrice B
for i = 1:13
    for j = 1:3      
        B(i,j) = diff(dx{i},U(j));            
    end
end

disp('Matrice B');pretty(B)

%% Détermination de la matrice C
for i = 1:7
    for j = 1:13      
        C(i,j) = diff(y{i},X(j));            
    end
end

disp('Matrice C');pretty(C)

%% Détermination de la matrice D
for i = 1:7
    for j = 1:3      
        D(i,j) = diff(y{i},U(j));            
    end
end

disp('Matrice D');pretty(D)

%% Sous matrices

I3x3 = A(1:3,4:6);
I2x2 = A(7:8,9:10);
I4x4 = C(4:7,7:10);

PP = A(4:7,1:3);
PS = A(4:7,7:8);
PC = A(4:7,11:13);
SP = A(9:10,1:3);
CC = A(11:13,11:13);
CV = B(11:13,:);
TDEFt = C(1:3,1:3);

disp('Matrice I3x3');pretty(I3x3)
disp('Matrice I2x2');pretty(I2x2)
disp('Matrice I4x4');pretty(I4x4)
disp('Matrice PP');pretty(PP)
disp('Matrice PS');pretty(PS)
disp('Matrice PC');pretty(PC)
disp('Matrice SP');pretty(SP)
disp('Matrice CC');pretty(CC)
disp('Matrice CV');pretty(CV)
disp('Matrice TDEFt');pretty(TDEFt)
















