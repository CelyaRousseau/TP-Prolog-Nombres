
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

inverse(N, I) :- N<0, I is (N*(-1)); N>=0, I is N.

cube(N) :- inverse(N, I), P is 1 rdiv 3,  C is round(I**P), I =:= C^3.
carre(N) :- inverse(N, I), P is 1 rdiv 2,  C is round(I**P), I =:= C^2.
est_puissance(N,X) :- inverse(N, I), P is 1 rdiv X,  C is round(I**P), I =:= C^X.

addition([X,Y| T1], T) :- 
	R is X+Y, append([R],T1,T).
soustraction([X,Y| T1], T) :- 
	R is X-Y, append([R],T1,T).
multiplication([X,Y| T1], T) :- 
	R is X*Y, append([R],T1,T).
division([X,Y| T1], T) :- 
	R is X/Y, append([R],T1,T).

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



/*assembler(T, R)
	Rôle : assembler chaque chiffre de chaque case pour ne former qu'un seul chiffre
	T est une liste à concaténer
	R est le résultat des éléments de la liste concaténés

	Par exemple : assembler([1,2], R) retourne R=12 
*/
assembler(T, R) :- atomic_list_concat(T, '', R1), atom_number(R1, R).



/* TODO 

la fonction est_carre. 
	est-carre(N, T)
	Rôle : déterminer si T est le carré de N
	Par exemple : carre(2, 16) retourne vrai mais carre(3, 16) retourne faux

la fonction carre. 
	carre(N)
	Rôle : déterminer si N est le carré d'un nombre
	Par exemple : carre(16) retourne vrai  mais carre(15) retourne faux

la fonction est_diviseur_premier. 
	est_diviseur_premier(N, D)
	Rôle : déterminé si N est un diviseur premier de D. Le diviseur premier d'un nombre est un nombre qui peut diviser le premier mais qui est aussi un nombre premier.
	Par exemple : est_diviseur_premier(11, 22) retourne vrai mais est_diviseur_premier(2, 22) retourne faux 

la fonction est_puissance. 
	est_puissance(T, N)
	Rôle : détermine si T est une puissance de N.
	Par exemple : est_puissance(16, 4) retourne vrai mais est_puissance(15, 4) retourne faux 

les fonctions addition et multiplication ne peuvent pas additionner plus de deux nombres */



/***********************
résolution grille 1 - ne marche pas
 **********************/

/* Définition de la grille 1 */
gr1([L1, L2]) :-
	gr1_ligne(L1),
	gr1_ligne(L2).
gr1_ligne([_, _]).

/* méthode de résolution de la grille 1 */
resoudre_gr1(T) :- 
	ligneA_gr1(T),
	ligneB_gr1(T),
	colonneA_gr1(T),
	colonneB_gr1(T).

/* On récupère les 2 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneA_gr1(T) :-
	nth1(N, T, [A,B]),
	N == 1,
	\+var(A),
	\+var(B),
	assembler([A, B], R),
	cube(R).

/* On récupère les 2 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 10 */
ligneB_gr1(T) :-
	nth1(N, T, [A,B]),
	N == 2,
	\+var(A),
	\+var(B),
	addition([A, B], R),
	nth0(0, R, R1),
	R1 is 10.

/* On récupère les 2 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneA_gr1(T) :-
	nth1(N, T, [A,_]),
	nth1(N1, T, [B,_]),
	N == 1,
	N1 == 2,	
	\+var(A),
	\+var(B),
	assembler([A, B], R),
	palindrome(R).

/* On récupère les 2 membres de la 2eme colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneB_gr1(T) :-
	nth1(N, T, [_,A]),
	nth1(N1, T, [_,B]),
	N == 1,
	N1 == 2,
	\+var(A),
	\+var(B),
	multiplication([A, B], R),
	nth0(0, R, R1),
	R1 is 2.





/***********************
résolution grille 2 - ne marche pas
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
	ligneA_gr2(T),
	ligneB_gr2(T),
	ligneC_gr2(T),
	ligneD_gr2(T),
	ligneE_gr2(T),
	colonneA_gr2(T),
	colonneB_gr2(T),
	colonneC_gr2(T),
	colonneD_gr2(T),
	colonneE_gr2(T),
	afficher(T).

/* On récupère les 3 membres de la 1ere ligne,
	on les multiplie et
	on vérifie que ça vaut 3 */
ligneA_gr2(T) :-
	member([A, B, C], T),
	multiplication([A, B, C], R),
	R is 3.

/* On récupère les 5 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 12 */
ligneB_gr2(T) :-
	member([_, [A, B, C, D, E]], T),
	addition([A, B, C, D, E], R),
	R is 12.

/* On récupère les 5 membres de la 3eme ligne,
	on récupère les 3 membres de la 4ème colonne
	on en fait 2 nombres et
	on vérifie que le premier est un carré du second */
ligneC_gr2(T) :-
	member([_, _, [A, B, C, D, E]], T),
	member([_, [_, _, _, G, _], [_, _, _, H, _], [_, _, _, I, _], _], T),
	assembler([A, B, C, D, E], R1),
	assembler([G, H, I], R2),
	est_carre(R1, R2).																						/* cette fonction n'existe pas */

/* On récupère les 4 membres de la 4eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneD_gr2(T) :-
	member([_, _, _, [_, B, C, D, E]], T),
	assembler([B, C, D, E], R),
	carre(R).																								/* cette fonction n'existe pas */

/* On récupère les 3 membres de la 5eme ligne,
	on les multiplie et
	on vérifie que ça vaut 18 */
ligneE_gr2(T) :-
	member([_, _, _, _, [A, B, C]], T),
	multiplication([A, B, C], R),
	R is 18.

/* On récupère les 3 membres de la 1ere colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneA_gr2(T) :-
	member([[A, _, _, _, _], [B, _, _, _, _], [C, _, _, _, _]], T),
	multiplication([A, B, C], R),
	R is 2.

/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneB_gr2(T) :-
	member([[_, A, _, _, _], [_, B, _, _, _], [_, C, _, _, _], [_, D, _, _, _], [_, E, _, _, _]], T),
	assembler([A, B, C, D, E], R),
	palindrome(R).

/* On récupère les 5 membres de la 3eme colonne,
	on récupère les 3 membres de la 5ème ligne,
	on en fait deux nombres et
	on vérifie que le premier est le carré du second */
colonneC_gr2(T) :-
	member([[_, _, A, _, _], [_, _, B, _, _], [_, _, C, _, _], [_, _, D, _, _], [_, _, E, _, _]], T),
	member([_, _, _, _, [F, G, H]], T),
	assembler([A, B, C, D, E], R1),
	assembler([F, G, H], R2),
	est_carre(R1, R2).																						/* cette fonction n'existe pas */

/* On récupère les 3 membres de la 4eme colonne,
	on les multiplie et
	on vérifie que ça vaut 12 */
colonneD_gr2(T) :-
	member([_, [_, _, _, B, _], [_, _, _, C, _], [_, _, _, D, _], _], T),
	multiplication([B, C, D], R),
	R is 12.

/* On récupère les 5 membres de la 5eme colonne,
	on récupère les 3 nombres de la 5ème ligne,
	on additionne les membres de la colonne,
	on fait un nombre avec ceux de la ligne et
	on vérifie que le premier est un diviseur premier du second */
colonneE_gr2(T) :-
	member([[_, _, _, _, A], [_, _, _, _, B], [_, _, _, _, C], [_, _, _, _, D], [_, _, _, _, E]], T),
	member([_, _, _, _, [F, G, H]], T),
	addition([A, B, C, D, E], R1),
	assembler([F, G, H], R2),
	est_diviseur_premier(R1, R2).																			/* cette fonction n'existe pas */





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
	ligneA_gr3(T),
	ligneB_gr3(T),
	ligneC_gr3(T),
	ligneD_gr3(T),
	ligneE_gr3(T),
	colonneA_gr3(T),
	colonneB_gr3(T),
	colonneC_gr3(T),
	colonneD_gr3(T),
	colonneE_gr3(T),
	afficher(T).

/* On récupère les 5 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
ligneA_gr3(T) :-
	member([A, B, C, D, E], T),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 4).																					/* cette fonction n'existe pas */

/* On récupère les 5 membres de la 2eme ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
ligneB_gr3(T) :-
	member([_, [A, B, C, D, E]], T),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 2).																					/* cette fonction n'existe pas */

/* On récupère les 5 membres de la 3eme ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneC_gr3(T) :-
	member([_, _, [A, B, C, D, E]], T),
	assembler([A, B, C, D, E], R),
	cube(R).

/* On récupère les 5 membres de la 4eme ligne,
	on récupère les 5 membres de la 5ème colonne
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
ligneD_gr3(T) :-
	member([_, _, _, [A, B, C, D, E]], T),
	member([[_, _, _, _, F], [_, _, _, _, G], [_, _, _, _, H], [_, _, _, _, I], [_, _, _, _, J]], T),
	addition([A, B, C, D, E], R1),		
	addition([F, G, H, I, J], R2),	
	R1 is R2.

/* On récupère les 4 membres de la 5eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneE_gr3(T) :-
	member([_, _, _, _, [A, B, C, D, _]], T),
	assembler([D, C, B, A], R),
	carre(R). 																								/* cette fonction n'existe pas */

/* On récupère les 5 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
colonneA_gr3(T) :-
	member([[A, _, _, _, _], [B, _, _, _, _], [C, _, _, _, _], [D, _, _, _, _], [E, _, _, _, _]], T),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 2). 																					/* cette fonction n'existe pas */

/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
colonneB_gr3(T) :-
	member([[_, A, _, _, _], [_, B, _, _, _], [_, C, _, _, _], [_, D, _, _, _], [_, E, _, _, _]], T),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 4). 																					/* cette fonction n'existe pas */

/* On récupère les 5 membres de la 3eme colonne,
	on en fait un nombre et
	on vérifie que c'est un cube */
colonneC_gr3(T) :-
	member([[_, _, A, _, _], [_, _, B, _, _], [_, _, C, _, _], [_, _, D, _, _], [_, _, E, _, _]], T),
	assembler([A, B, C, D, E], R),
	cube(R).

/* On récupère les 5 membres de la 4eme colonne,
	on récupère les 4 membres de la 5ème ligne,
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
colonneD_gr3(T) :-
	member([[_, _, _, A, _], [_, _, _, B, _], [_, _, _, C, _], [_, _, _, D, _], [_, _, _, E, _]], T),
	member([_, _, _, _, [F, G, H, I, _]], T),
	addition([A, B, C, D, E], R1),
	addition([F, G, H, I], R2),
	R1 is R2.

/* On récupère les 4 membres de la 5eme colonne,
	on en fait un nombre et
	on vérifie que c'est un carré */
colonneE_gr3(T) :-
	member([[_, _, _, _, A], [_, _, _, _, B], [_, _, _, _, C], [_, _, _, _, D], [_, _, _, _, E]], T),
	assembler([E, D, C, B, A], R),
	carre(R). 																								/* cette fonction n'existe pas */

/* A TESTER : RESOLUTION VIA MATH 
ligneA(T) :-  nombrePrecedent(X, 20). 
ligneB(T) :-  nombreSuivant(X,909).
ligneC(T) :-  nombreAyantDizaine(X, 8).
ligneD(T) :-  between(100, 999, N), palindrome(X).
colonneA(T) :-  20 + 15.
colonneB(T) :-  nombrePrecedent(X, 100).
colonneC(T) :-  100 + 50 + 30 + 5.
colonneD(T) :-  (50x2) +5 .

*/

/* predicat final 
resoudre(T) :-
	ligneA(T),
	ligneB(T),
	ligneC(T),
	ligneD(T),
	colonneA(T),
	colonneB(T),
	colonneC(T),
	colonneD(T).
	
*/
