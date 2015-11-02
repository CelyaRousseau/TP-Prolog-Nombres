
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

inverse(N, I) :- N<0, I is (N*(-1)); N>=0, I is N.

cube(N) :- inverse(N, I), P is 1 rdiv 3,  C is round(I**P), I =:= C^3.

/* la fonction carre. 
	carre(N)
	Rôle : déterminer si N est le carré d'un nombre
	Par exemple : carre(16) retourne vrai  mais carre(15) retourne faux */
carre(N) :- inverse(N, I), P is 1 rdiv 2,  C is round(I**P), I =:= C^2.

/* la fonction est_puissance. 
	est_puissance(T, N)
	Rôle : détermine si T est une puissance de N.
	Par exemple : est_puissance(16, 4) retourne vrai mais est_puissance(15, 4) retourne faux */
est_puissance(N,X) :- inverse(N, I), P is 1 rdiv X,  C is round(I**P), I =:= C^X.

/* la fonction est_carre. 
	est_carre(N, T)
	Rôle : déterminer si T est le carré de N
	Par exemple : carre(2, 16) retourne vrai mais carre(3, 16) retourne faux */
est_carre(N, C) :- inverse(N, I), P is 1 rdiv 2,  C is round(I**P), I =:= C^2.


addition([X,Y| T1], T) :- 
	R is X+Y, append([R],T1,T).
soustraction([X,Y| T1], T) :- 
	R is X-Y, append([R],T1,T).
multiplication([X,Y| T1], T) :- 
	R is X*Y, append([R],T1,T).
division([X,Y| T1], T) :- 
	R is X/Y, append([R],T1,T).

additions([X], R) :- R is X.
additions([X,Y| T1], R) :- SR is X+Y, append([SR],T1,T), additions(T, R).

multiplications([X], R) :- R is X.
multiplications([X,Y| T1], R) :- SR is X*Y, append([SR],T1,T), multiplications(T, R).

/* Calcul (sachant que la liste est dans le bonne ordre ) */
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


nonpremier(1).
nonpremier(X) :- Y is X-1, between(2,Y,Z), between(Z,Y,T), X =:= T*Z.
premier(X) :- nonpremier(X), !, fail.
premier(_).

/* la fonction est_diviseur_premier. 
	est_diviseur_premier(N, D)
	Rôle : déterminé si N est un diviseur premier de D. Le diviseur premier d'un nombre est un nombre qui peut diviser le premier mais qui est aussi un nombre premier.
	Par exemple : est_diviseur_premier(11, 22) retourne vrai mais est_diviseur_premier(2, 22) retourne faux */
est_diviseur_premier(N,D) :- premier(N), R is D/N, integer(R).

/***********************
 afficher la grille 
 **********************/

/* afficher la grille ligne par ligne en récursif */
afficher([H|T]) :- afficher_ligne(H), afficher(T).
/* affiche une ligne cellule par cellule et séparer par une virgule en récursif */
afficher_ligne([H,H2|T]) :- afficher_cellule(H), write(','), afficher_ligne([H2|T]).
/* si la ligne ne contient qu'une valeur, on affiche juste la valeur d'une cellule */
afficher_ligne([X]) :- afficher_cellule(X), nl.
/* afficher une cellule. Si la valeur est null, on affiche un underscore sinon on affiche la valeur */
afficher_cellule(X) :- var(X), write('_').
afficher_cellule(X) :- \+var(X), write(X).

cursor(X,Y) :- write('\33\['), /*put(27), put(91),*/
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

/*assembler(T, R)
	Rôle : assembler chaque chiffre de chaque case pour ne former qu'un seul chiffre
	T est une liste à concaténer
	R est le résultat des éléments de la liste concaténés

	Par exemple : assembler([1,2], R) retourne R=12 
*/
assembler(T, R) :- atomic_list_concat(T, '', R1), atom_number(R1, R).



/* TODO 

les fonctions addition et multiplication ne peuvent pas additionner plus de deux nombres */


/***********************
résolution grille 1 - MARCHE !
 **********************/

/* Définition de la grille 1 */
gr1([L1, L2]) :-
	gr1_ligne(L1),
	gr1_ligne(L2).
gr1_ligne([_, _]).

/* méthode de résolution de la grille 1 */
resoudre_gr1(T) :- 
	clear(),
	gr1(T),
	afficher_gr1(),
	write_position(4,0,'Calcul en cours... '),
	ligneA_gr1(T),
	ligneB_gr1(T),
	colonneA_gr1(T),
	colonneB_gr1(T),
	write_position(4,0,'Resolution terminee '),
	write_position(5,0,'                    ').

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


/***********************
résolution grille 2 - beaucoup trop lent
 **********************/

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
	clear(),
	gr2(T),
	afficher_gr2(),
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
	write_position(7,0,'                    ').

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


/***********************
résolution grille 3 - ne marche pas
 **********************/

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
	clear(),
	gr3(T),
	afficher_gr2(),
	write_position(6,0,'Calcul en cours...'),
	colonneA_gr3(T),
	ligneE_gr3(T),
	ligneA_gr3(T),
	colonneB_gr3(T),
	ligneB_gr3(T),
	colonneC_gr3(T),
	ligneC_gr3(T),
	colonneD_gr3(T),
	ligneD_gr3(T),
	colonneE_gr3(T),	
	write_position(6,0,'Resolution terminee '),
	write_position(7,0,'                    ').

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
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	assembler([D, C, B, A], R),
	carre(R),
	write_position(0,8,A),
	write_position(1,8,B),
	write_position(2,8,C),
	write_position(3,8,D),
	write_position(7,0,'Pending...         ').	
