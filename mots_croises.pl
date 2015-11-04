/*---------------------- REGLES MATHEMATIQUES ------------------------*/

/* la fonction nombre_precedent : 
	nombre_precedent(X, P)
	Rôle : déterminer si P est le nombre précédant X / peut également calculer le nombre précédent de X
	Exemple : nombre_precedent(17,16) retourne vrai, nombre_precedent(10,20) retourne faux, nombre_precedent(20,X) retourne 19 */
nombre_precedent(X, P) :- P is X - 1.

/* la fonction nombre_suivant :
	nombre_suivant(X, S)
	Rôle : déterminer si S est le nombre suivant X / peut également calculer le nombre suivant de X
	Exemple : nombre_suivant(16,17) retourne vrai, nombre_suivant(10,20) retourne faux, nombre_suivant(20,X) retourne 21 */
nombre_suivant(X, S) :- S is X + 1.

/* la fonction nombre_ayant_dizaine : 
	nombre_ayant_dizaine(X, N)
	Rôle : déterminer si N est compris dans la dizaine spécifiée / peut également donner les nombre suivant ayant pour dizaine X
	Exemple : nombre_ayant_dizaine(8,83) retourne vrai, nombre_ayant_dizaine(8,20) retourne faux, nombre_ayant_dizaine(8,X) retourne 80, 81, 82, 83, 84, 85, 86, 87, 88, 89. */
nombre_ayant_dizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

/* la fonction palindrome : 
	palindrome(X)
	Rôle : déterminer si X est un palindrome
	Exemple : palindrome(12321) retournera vrai, palindrome(125) retournera faux */
palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

/* la fonction cube :
	cube(N)
	Rôle : déterminer si N est un cube
	Exemple : cube(9) retournera vrai, cube(98) retournera faux */
cube(N) :- P is 1 rdiv 3,  C is round(N**P), N =:= C^3.

/* la fonction carre :
	carre(N)
	Rôle : déterminer si N est un carré
	Par exemple : carre(16) retourne vrai  mais carre(15) retournera faux */
carre(N) :- P is 1 rdiv 2,  C is round(N**P), N =:= C^2.

/* la fonction est_puissance : 
	est_puissance(Y, X)
	Rôle : détermine si Y est une puissance de X.
	Par exemple : est_puissance(16, 4) retourne vrai mais est_puissance(15, 4) retourne faux */
est_puissance(Y,X) :- between(0,16,N),  Y is X^N.

/* la fonction est_carre : 
	est_carre(N, C)
	Rôle : déterminer si N est le carré de C
	Par exemple : est_carre(16, 4) retourne vrai mais est_carre(3, 16) retourne faux */
est_carre(N, C) :- P is 1 rdiv 2,  C is round(N**P), N =:= C^2.

/* les fonctions suivantes : 
	-> addition(L1,L2), soustraction(L1,L2), multiplication(L1,L2), division(L1,L2) sont des sous-fonctions 
	de la fonction Calculer(L1,L2,X) présenté ci-dessous. 
	Rôle : effectuer un calcul entre les deux premier termes d'une liste et retourné la liste en remplaçant les deux premiers termes par le résultat.
	Par exemple : addition([1,2,3], T) retournera T = [3,3] */
addition([X,Y| T1], T) :- R is X+Y, append([R],T1,T).
soustraction([X,Y| T1], T) :- R is X-Y, append([R],T1,T).
multiplication([X,Y| T1], T) :- R is X*Y, append([R],T1,T).
division([X,Y| T1], T) :- R is X/Y, append([R],T1,T).

/* la fonction additions. 
	additions(L1, R)
	Rôle : déterminer le resultat R de l'addition des termes d'une liste L1
	Par exemple : additions([1,2,3,4], R) retournera R = 10 car 1+2+3+4 = 10 */
additions([X], R) :- R is X.
additions([X,Y| T1], R) :- SR is X+Y, append([SR],T1,T), additions(T, R).

/* la fonction multiplications. 
	multiplications(L1, R)
	Rôle : déterminer le resultat R de la multiplication des termes d'une liste L1
	Par exemple : multiplications([1,2,3,4], R) retournera R = 24 car 1*2*3*4 = 24 */
multiplications([X], R) :- R is X.
multiplications([X,Y| T1], R) :- SR is X*Y, append([SR],T1,T), multiplications(T, R).

/* Calcul (sachant que la liste est dans le bonne ordre ) */
/* la fonction calculer. 
	calculer(L1, L2, R)
	Rôle : déterminer le resultat R du calcul des termes d'une liste L1
	Par exemple : calculer([1,2,3,4],[+,*,-], R) retournera R = 5 car (1+2)*3-4 = 24 
	Attention : Cette fonction ne gère pas la priorisation des calculs avec parenthèse, il calcule simplement de gauche à droite, 
	les termes doivent donc être triés préalablement si besoin */
calculer(L1, [], X) :- X is L1.
calculer(L1, [A|T2], R) :- 
	(
		nth0(0, [A], +), addition(L1, TR);
		nth0(0, [A], -), soustraction(L1, TR);
		nth0(0, [A], *), multiplication(L1, TR);
		nth0(0, [A], /), division(L1, TR)
	), 
	calculer(TR, T2, R).


def1A('Cube').
def1B('La somme des chiffres vaut 10').
def1a('palindrome').
def1b('la produit des chiffres vaut 2').

definitions_gr1(X) :- def1A(X); def1B(X); def1a(X); def1b(X).

traductions_gr1(L) :- definitions_gr1(X), split_string(X, ' ', '', L).


non_premier(1).
non_premier(X) :- Y is X-1, between(2,Y,Z), between(Z,Y,T), X =:= T*Z.
premier(X) :- non_premier(X), !, fail.
premier(_).

/* la fonction est_diviseur_premier. 
	est_diviseur_premier(N, D)
	Rôle : déterminé si N est un diviseur premier de D. Le diviseur premier d'un nombre est un nombre qui peut diviser le premier mais qui est aussi un nombre premier.
	Par exemple : est_diviseur_premier(11, 22) retourne vrai mais est_diviseur_premier(2, 22) retourne faux */
est_diviseur_premier(N,D) :- premier(N), R is D/N, integer(R).

/*--------------------- AFFICHER LA GRILLE -------------------------*/


cursor(X,Y) :- write('\33\['), /*put(29), put(91),*/
               write(Y),
               write(';'), /*put(59),*/
               write(X),
               write('H'). /*put(72).*/


clear :- write('\33\[2J').

write_position(X, Y, V) :-
	cursor(X,Y),
	write(V).

afficher_gr1 :-
writeln('_,_'),
writeln('_,_').

afficher_gr2 :- 
	writeln('_,_,_,_,_'),
	writeln('_,_,_,_,_'),
	writeln('_,_,_,_,_'),
	writeln('_,_,_,_,_'),
	writeln('_,_,_,_,_').

afficher_grEx :- 
	writeln('_,_,_,_'),
	writeln('_,_,_,_'),
	writeln('_,_,_,_'),
	writeln('_,_,_,_').

/* assembler(T, R)
	Rôle : assembler chaque chiffre de chaque case pour ne former qu'un seul chiffre
	T est une liste à concaténer
	R est le résultat des éléments de la liste concaténés

	Par exemple : assembler([1,2], R) retourne R=12 */
assembler(T, R) :- atomic_list_concat(T, '', R1), atom_number(R1, R).



/*--------------------- RESOLUTION GRILLE 1 ------------------------*/



/* Définition de la grille 1 */
gr1([L1, L2]) :-
	gr1_ligne(L1),
	gr1_ligne(L2).
gr1_ligne([_, _]).

/* méthode de résolution de la grille 1 */
resoudre_gr1(T) :- 
	clear,
	gr1(T),
	afficher_gr1,
	write_position(4,0,'Calcul en cours... '),
	ligneA_gr1(T),
	ligneB_gr1(T),
	colonneA_gr1(T),
	colonneB_gr1(T),
	write_position(4,0,'Resolution terminee '),
	write_position(5,0,'                    '), !.

/* On récupère les 2 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneA_gr1(T) :-
	write_position(5,0,'Calcul L A'),
	nth1(1, T, [A,B]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	carre(R),
	write_position(0,0,A),
	write_position(0,2,B).

/* On récupère les 2 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 10 */
ligneB_gr1(T) :-
	write_position(5,0,'Calcul L B'),
	nth1(2, T, [A,B]),
	between(1, 9, A),
	between(0, 9, B),
	additions([A, B], R),
	R is 10.
	/*write_position(1,0,A),
	write_position(1,2,B).*/

/* On récupère les 2 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneA_gr1(T) :-
	write_position(5,0,'Calcul C A'),
	nth1(1, T, [A,_]),
	nth1(2, T, [B,_]),	
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	palindrome(R),
	write_position(0,0,A),
	write_position(1,0,B).

/* On récupère les 2 membres de la 2eme colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneB_gr1(T) :-
	write_position(5,0,'Calcul C B'),
	nth1(1, T, [_,A]),
	nth1(2, T, [_,B]),
	between(1, 9, A),
	between(0, 9, B),
	multiplications([A, B], R),
	R is 2,
	write_position(0,2,A),
	write_position(1,2,B).



/*--------------------- RESOLUTION GRILLE 2 ------------------------*/



/* Définition de la grille 2 */
gr2([L1, L2, L3, L4, L5]) :-
	gr2_ligne(L1),
	gr2_ligne(L2),
	gr2_ligne(L3),
	gr2_ligne(L4),
	gr2_ligne(L5).
gr2_ligne([_, _, _, _, _]).

/* méthode de résolution de la grille 2 */
resoudre_gr2(T) :- 
	clear,
	gr2(T),
	afficher_gr2,
	write_position(6,0,'Calcul en cours...'),
	colonneA_gr2(T),
	ligneA_gr2(T),
	colonneB_gr2(T),
	ligneB_gr2(T),
	colonneC_gr2(T),
	ligneC_gr2(T),
	colonneD_gr2(T),
	ligneD_gr2(T),
	colonneE_gr2(T),
	ligneE_gr2(T),	
	write_position(6,0,'Resolution terminee '),
	write_position(7,0,'                    '), !.

/* On récupère les 3 membres de la 1ere ligne,
	on les multiplie et
	on vérifie que ça vaut 3 */
ligneA_gr2(T) :-
	write_position(7,0,'Calcul L A'),
	nth1(1, T, [A,B,C,_,_]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 3,
	write_position(0,0,A),
	write_position(0,2,B),
	write_position(0,4,C),
	write_position(7,0,'Pending...         ').

/* On récupère les 5 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 12 */
ligneB_gr2(T) :-
	write_position(7,0,'Calcul L B'),
	nth1(2, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	additions([A, B, C, D, E], R),
	R is 12,
	write_position(1,0,A),
	write_position(1,2,B),
	write_position(1,4,C),
	write_position(1,6,D),
	write_position(1,8,E),
	write_position(7,0,'Pending...         ').

/* On récupère les 5 membres de la 3eme ligne,
	on récupère les 3 membres de la 4ème colonne
	on en fait 2 nombres et
	on vérifie que le premier est un carré du second */
ligneC_gr2(T) :-
	write_position(7,0,'Calcul L C'),
	nth1(3, T, [A, B, C, D, E]),
	nth1(2, T, [_, _, _, G, _]),
	nth1(3, T, [_, _, _, H, _]),
	nth1(4, T, [_, _, _, I, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	between(1, 9, G),
	between(0, 9, H),
	between(0, 9, I),
	assembler([A, B, C, D, E], R1),
	assembler([G, H, I], R2),
	est_carre(R1, R2),
	write_position(2,0,A),
	write_position(2,2,B),
	write_position(2,4,C),
	write_position(2,6,D),
	write_position(2,8,E),
	write_position(7,0,'Pending...         ').																	

/* On récupère les 4 membres de la 4eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneD_gr2(T) :-
	write_position(7,0,'Calcul L D'),
	nth1(4, T, [_, B, C, D, E]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([B, C, D, E], R),
	carre(R),
	write_position(3,2,B),
	write_position(3,4,C),
	write_position(3,6,D),
	write_position(3,8,E),
	write_position(7,0,'Pending...         ').																				

/* On récupère les 3 membres de la 5eme ligne,
	on les multiplie et
	on vérifie que ça vaut 18 */
ligneE_gr2(T) :-
	write_position(7,0,'Calcul L E'),
	nth1(5, T, [A, B, C, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 18,
	write_position(4,0,A),
	write_position(4,2,B),
	write_position(4,4,C),
	write_position(7,0,'Pending...         ').

/* On récupère les 3 membres de la 1ere colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneA_gr2(T) :-
	write_position(7,0,'Calcul C A'),
	nth1(1, T, [A, _, _, _, _]),
	nth1(2, T, [B, _, _, _, _]),
	nth1(3, T, [C, _, _, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 2,
	write_position(0,0,A),
	write_position(1,0,B),
	write_position(2,0,C),
	write_position(7,0,'Pending...         ').

/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneB_gr2(T) :-
	write_position(7,0,'Calcul C B'),
	nth1(1, T, [_, A, _, _, _]),
	nth1(2, T, [_, B, _, _, _]),
	nth1(3, T, [_, C, _, _, _]),
	nth1(4, T, [_, D, _, _, _]),
	nth1(5, T, [_, E, _, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	palindrome(R),
	write_position(0,2,A),
	write_position(1,2,B),
	write_position(2,2,C),
	write_position(3,2,D),
	write_position(4,2,E),
	write_position(7,0,'Pending...         ').

/* On récupère les 5 membres de la 3eme colonne,
	on récupère les 3 membres de la 5ème ligne,
	on en fait deux nombres et
	on vérifie que le premier est le carré du second */
colonneC_gr2(T) :-
	write_position(7,0,'Calcul C C'),
	nth1(1, T, [_, _, A, _, _]),
	nth1(2, T, [_, _, B, _, _]),
	nth1(3, T, [_, _, C, _, _]),
	nth1(4, T, [_, _, D, _, _]),
	nth1(5, T, [_, _, E, _, _]),
	nth1(5, T, [F, G, H, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	between(1, 9, F),
	between(0, 9, G),
	between(0, 9, H),
	assembler([A, B, C, D, E], R1),
	assembler([F, G, H], R2),
	est_carre(R1, R2),
	write_position(0,4,A),
	write_position(1,4,B),
	write_position(2,4,C),
	write_position(3,4,D),
	write_position(4,4,E),
	write_position(7,0,'Pending...         ').																						

/* On récupère les 3 membres de la 4eme colonne,
	on les multiplie et
	on vérifie que ça vaut 12 */
colonneD_gr2(T) :-
	write_position(7,0,'Calcul C D'),
	nth1(2, T, [_, _, _, B, _]),
	nth1(3, T, [_, _, _, C, _]),
	nth1(4, T, [_, _, _, D, _]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	multiplications([B, C, D], R),
	R is 12,
	write_position(1,6,B),
	write_position(2,6,C),
	write_position(3,6,D),
	write_position(7,0,'Pending...         ').

/* On récupère les 5 membres de la 5eme colonne,
	on récupère les 3 nombres de la 5ème ligne,
	on additionne les membres de la colonne,
	on fait un nombre avec ceux de la ligne et
	on vérifie que le premier est un diviseur premier du second */
colonneE_gr2(T) :-
	write_position(7,0,'Calcul C E'),
	nth1(1, T, [_, _, _, _, A]),
	nth1(2, T, [_, _, _, _, B]),
	nth1(3, T, [_, _, _, _, C]),
	nth1(4, T, [_, _, _, _, D]),
	nth1(5, T, [_, _, _, _, E]),
	nth1(5, T, [F, G, H, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	between(1, 9, F),
	between(0, 9, G),
	between(0, 9, H),
	additions([A, B, C, D, E], R),
	assembler([F, G, H], R2),
	est_diviseur_premier(R, R2),
	write_position(0,8,A),
	write_position(1,8,B),
	write_position(2,8,C),
	write_position(3,8,D),
	write_position(4,8,E),
	write_position(4,0,F),
	write_position(4,2,G),
	write_position(4,4,H),
	write_position(7,0,'Pending...         ').																			



/*--------------------- RESOLUTION GRILLE 3 ------------------------*/



/* Définition de la grille 3 */
gr3([L1, L2, L3, L4, L5]) :-
	gr3_ligne(L1),
	gr3_ligne(L2),
	gr3_ligne(L3),
	gr3_ligne(L4),
	gr3_ligne(L5).
gr3_ligne([_, _, _, _, _]).

/* méthode de résolution de la grille 3 */
resoudre_gr3(T) :- 
	clear,
	gr3(T),
	afficher_gr2,
	write_position(6,0,'Calcul en cours...'),
	ligneC_gr3(T),
	colonneC_gr3(T),
	colonneE_gr3(T),
	ligneE_gr3(T),
	ligneA_gr3(T),
	colonneA_gr3(T),
	ligneB_gr3(T),
	colonneB_gr3(T),
	ligneD_gr3(T),
	colonneD_gr3(T),	
	write_position(6,0,'Resolution terminee '),
	write_position(7,0,'                    '), !.

/* On récupère les 5 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
ligneA_gr3(T) :-
	write_position(7,0,'Calcul L A'),
	nth1(1, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 4),
	write_position(0,0,A),
	write_position(0,2,B),
	write_position(0,4,C),
	write_position(0,6,D),
	write_position(0,8,E),
	write_position(7,0,'Pending...         ').																					

/* On récupère les 5 membres de la 2eme ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
ligneB_gr3(T) :-
	write_position(7,0,'Calcul L B'),
	nth1(2, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 2),
	write_position(1,0,A),
	write_position(1,2,B),
	write_position(1,4,C),
	write_position(1,6,D),
	write_position(1,8,E),
	write_position(7,0,'Pending...         ').																			

/* On récupère les 5 membres de la 3eme ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneC_gr3(T) :-
	write_position(7,0,'Calcul L C'),
	nth1(3, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	cube(R),
	write_position(2,0,A),
	write_position(2,2,B),
	write_position(2,4,C),
	write_position(2,6,D),
	write_position(2,8,E),
	write_position(7,0,'Pending...         ').	

/* On récupère les 5 membres de la 4eme ligne,
	on récupère les 5 membres de la 5ème colonne
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
ligneD_gr3(T) :-
	write_position(7,0,'Calcul L D'),
	nth1(4, T, [A, B, C, D, E]),
	nth1(1, T, [_, _, _, _, F]),
	nth1(2, T, [_, _, _, _, G]),
	nth1(3, T, [_, _, _, _, H]),
	nth1(4, T, [_, _, _, _, I]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	between(1, 9, F),
	between(0, 9, G),
	between(0, 9, H),
	between(0, 9, I),
	additions([A, B, C, D, E], R1),		
	additions([F, G, H, I], R2),	
	R1 is R2,
	write_position(3,0,A),
	write_position(3,2,B),
	write_position(3,4,C),
	write_position(3,6,D),
	write_position(3,8,E),
	write_position(0,8,F),
	write_position(1,8,G),
	write_position(2,8,H),
	write_position(3,8,I),
	write_position(7,0,'Pending...         ').	

/* On récupère les 4 membres de la 5eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneE_gr3(T) :-
	write_position(7,0,'Calcul L E'),
	nth1(5, T, [A, B, C, D, _]),
	between(0, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(1, 9, D),
	assembler([D, C, B, A], R),
	carre(R),
	write_position(4,0,A),
	write_position(4,2,B),
	write_position(4,4,C),
	write_position(4,6,D),
	write_position(7,0,'Pending...         ').																									

/* On récupère les 5 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
colonneA_gr3(T) :-
	write_position(7,0,'Calcul C A'),
	nth1(1, T, [A, _, _, _, _]),
	nth1(2, T, [B, _, _, _, _]),
	nth1(3, T, [C, _, _, _, _]),
	nth1(4, T, [D, _, _, _, _]),
	nth1(5, T, [E, _, _, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 2),
	write_position(0,0,A),
	write_position(1,0,B),
	write_position(2,0,C),
	write_position(3,0,D),
	write_position(4,0,E),
	write_position(7,0,'Pending...         ').																						

/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
colonneB_gr3(T) :-
	write_position(7,0,'Calcul C B'),
	nth1(1, T, [_, A, _, _, _]),
	nth1(2, T, [_, B, _, _, _]),
	nth1(3, T, [_, C, _, _, _]),
	nth1(4, T, [_, D, _, _, _]),
	nth1(5, T, [_, E, _, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 4),
	write_position(0,2,A),
	write_position(1,2,B),
	write_position(2,2,C),
	write_position(3,2,D),
	write_position(4,2,E),
	write_position(7,0,'Pending...         ').																						

/* On récupère les 5 membres de la 3eme colonne,
	on en fait un nombre et
	on vérifie que c'est un cube */
colonneC_gr3(T) :-
	write_position(7,0,'Calcul C C'),
	nth1(1, T, [_, _, A, _, _]),
	nth1(2, T, [_, _, B, _, _]),
	nth1(3, T, [_, _, C, _, _]),
	nth1(4, T, [_, _, D, _, _]),
	nth1(5, T, [_, _, E, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	cube(R),
	write_position(0,4,A),
	write_position(1,4,B),
	write_position(2,4,C),
	write_position(3,4,D),
	write_position(4,4,E),
	write_position(7,0,'Pending...         ').	

/* On récupère les 5 membres de la 4eme colonne,
	on récupère les 4 membres de la 5ème ligne,
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
colonneD_gr3(T) :-
	write_position(7,0,'Calcul C D'),
	nth1(1, T, [_, _, _, A, _]),
	nth1(2, T, [_, _, _, B, _]),
	nth1(3, T, [_, _, _, C, _]),
	nth1(4, T, [_, _, _, D, _]),
	nth1(5, T, [_, _, _, E, _]),
	nth1(5, T, [F, G, H, I, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	between(1, 9, F),
	between(0, 9, G),
	between(0, 9, H),
	between(0, 9, I),
	additions([A, B, C, D, E], R1),
	additions([F, G, H, I], R2),
	R1 is R2,
	write_position(0,6,A),
	write_position(1,6,B),
	write_position(2,6,C),
	write_position(3,6,D),
	write_position(4,6,E),
	write_position(4,0,F),
	write_position(4,2,G),
	write_position(4,4,H),
	write_position(4,6,I),
	write_position(7,0,'Pending...         ').	

/* On récupère les 4 membres de la 5eme colonne,
	on en fait un nombre et
	on vérifie que c'est un carré */
colonneE_gr3(T) :-
	write_position(7,0,'Calcul C E'),
	nth1(1, T, [_, _, _, _, A]),
	nth1(2, T, [_, _, _, _, B]),
	nth1(3, T, [_, _, _, _, C]),
	nth1(4, T, [_, _, _, _, D]),
	between(0, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(1, 9, D),
	assembler([D, C, B, A], R),
	carre(R),
	write_position(0,8,A),
	write_position(1,8,B),
	write_position(2,8,C),
	write_position(3,8,D),
	write_position(7,0,'Pending...         ').	




/*--------------------- RESOLUTION GRILLE EXEMPLE ------------------------*/



/* Définition de la grille exemple */
grEx([L1, L2, L3, L4]) :-
	grEx_ligne(L1),
	grEx_ligne(L2),
	grEx_ligne(L3),
	grEx_ligne(L4).
grEx_ligne([_, _, _, _]).

/* méthode de résolution de la grille exemple */
resoudre_grEx(T) :- 
	clear,
	grEx(T),
	afficher_grEx,
	write_position(6,0,'Calcul en cours...'),
	ligneD_grEx(T),
	colonneC_grEx(T),	
	ligneB_grEx(T),
	ligneA_grEx(T),	
	colonneB_grEx(T),
	colonneA_grEx(T),		
	colonneD_grEx(T),	
	ligneC_grEx(T),
	write_position(6,0,'Resolution terminee '),
	write_position(7,0,'                    '), !.

/* On récupère les 2 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est le nombre qui précède 20 */
ligneA_grEx(T) :-
	write_position(7,0,'Calcul L A'),
	nth1(1, T, [A, B, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	nombre_precedent(20, R),
	write_position(0,0,A),
	write_position(0,2,B),
	write_position(7,0,'Pending...         ').																					

/* On récupère les 3 membres de la 2eme ligne,
	on en fait un nombre et
	on vérifie que c'est le nombre suivant 909 */
ligneB_grEx(T) :-
	write_position(7,0,'Calcul L B'),
	nth1(2, T, [_, B, C, D]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	assembler([B, C, D], R),
	nombre_suivant(909,R),
	write_position(1,2,B),
	write_position(1,4,C),
	write_position(1,6,D),
	write_position(7,0,'Pending...         ').																			

/* On récupère les 2 membres de la 3eme ligne,
	on en fait un nombre et
	on vérifie qu'il possède 8 dizaines */
ligneC_grEx(T) :-
	write_position(7,0,'Calcul L C'),
	nth1(3, T, [_, _, C, D]),
	between(1, 9, C),
	between(0, 9, D),
	assembler([ C, D], R),
	nombre_ayant_dizaine(8,R),
	write_position(2,4,C),
	write_position(2,6,D),
	write_position(7,0,'Pending...         ').	

/* On récupère les 3 membres de la 4eme ligne,
	on en fait un nombre et
	on vérifie qu'il possède le même chiffre aux centaines et aux unités (palindrome)*/
ligneD_grEx(T) :-
	write_position(7,0,'Calcul L D'),
	nth1(4, T, [A, B, C, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	assembler([A, B, C], R),
	palindrome(R),
	write_position(3,0,A),
	write_position(3,2,B),
	write_position(3,4,C),
	write_position(7,0,'Pending...         ').

/* On récupère les 2 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est 20+15 */
colonneA_grEx(T) :-
	write_position(7,0,'Calcul C A'),
	nth1(3, T, [C, _, _, _]),
	nth1(4, T, [D, _, _, _]),
	between(1, 9, C),
	between(0, 9, D),
	assembler([C, D], R),
	calculer([20,15],[+],R),
	write_position(2,0,C),
	write_position(3,0,D),
	write_position(7,0,'Pending...         ').																						

/* On récupère les 2 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est celui qui précède 100 */
colonneB_grEx(T) :-
	write_position(7,0,'Calcul C B'),
	nth1(1, T, [_, A, _, _]),
	nth1(2, T, [_, B, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	nombre_precedent(100,R),
	write_position(0,2,A),
	write_position(1,2,B),
	write_position(7,0,'Pending...         ').																						

/* On récupère les 3 membres de la 3eme colonne,
	on en fait un nombre et
	on vérifie que c'est 100+50+30+5 */
colonneC_grEx(T) :-
	write_position(7,0,'Calcul C C'),
	nth1(2, T, [_, _, B, _]),
	nth1(3, T, [_, _, C, _]),
	nth1(4, T, [_, _, D, _]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	assembler([B, C, D], R),
	calculer([100,50,30,5],[+,+,+],R),
	write_position(1,4,B),
	write_position(2,4,C),
	write_position(3,4,D),
	write_position(7,0,'Pending...         ').	

/* On récupère les 3 membres de la 4eme colonne,
	on en fait un nombre
	on vérifie que c'est (50*2)+5 */
colonneD_grEx(T) :-
	write_position(7,0,'Calcul C D'),
	nth1(1, T, [_, _, _, A]),
	nth1(2, T, [_, _, _, B]),
	nth1(3, T, [_, _, _, C]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	assembler([A,B,C],R),
	calculer([50,2,5],[*,+],R),
	write_position(0,6,A),
	write_position(1,6,B),
	write_position(2,6,C),
	write_position(7,0,'Pending...         ').