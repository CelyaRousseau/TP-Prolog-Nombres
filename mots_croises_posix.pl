
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

cube(N) :- P is 1 rdiv 3,  C is round(N**P), N =:= C^3.

/* la fonction carre. 
	carre(N)
	Rôle : déterminer si N est le carré d'un nombre
	Par exemple : carre(16) retourne vrai  mais carre(15) retourne faux */
carre(N) :- P is 1 rdiv 2,  C is round(N**P), N =:= C^2.

/* la fonction est_puissance. 
	est_puissance(T, N)
	Rôle : détermine si T est une puissance de N.
	Par exemple : est_puissance(16, 4) retourne vrai mais est_puissance(15, 4) retourne faux */
est_puissance(Y,X) :- between(0,16,N),  Y is X^N.

/* la fonction est_carre. 
	est_carre(N, T)
	Rôle : déterminer si T est le carré de N
	Par exemple : carre(2, 16) retourne vrai mais carre(3, 16) retourne faux */
est_carre(N, C) :- P is 1 rdiv 2,  C is round(N**P), N =:= C^2.


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
afficher([]) :- !.
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
	writeln('Calcul en cours...'),
	gr1(T),
	ligneA_gr1(T),
	ligneB_gr1(T),
	colonneA_gr1(T),
	colonneB_gr1(T),	
	afficher(T), !.

/* On récupère les 2 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneA_gr1(T) :-
	nth1(1, T, [A,B]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	carre(R).

/* On récupère les 2 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 10 */
ligneB_gr1(T) :-
	nth1(2, T, [A,B]),
	between(1, 9, A),
	between(0, 9, B),
	additions([A, B], R),
	R is 10.

/* On récupère les 2 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneA_gr1(T) :-
	nth1(1, T, [A,_]),
	nth1(2, T, [B,_]),	
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	palindrome(R).

/* On récupère les 2 membres de la 2eme colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneB_gr1(T) :-
	nth1(1, T, [_,A]),
	nth1(2, T, [_,B]),
	between(1, 9, A),
	between(0, 9, B),
	multiplications([A, B], R),
	R is 2.	

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
	writeln('Calcul en cours...'),
	gr2(T),
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
	afficher(T), !.
		
/* On récupère les 3 membres de la 1ere ligne,
	on les multiplie et
	on vérifie que ça vaut 3 */
ligneA_gr2(T) :-
	nth1(1, T, [A,B,C,_,_]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 3.
				
/* On récupère les 5 membres de la 2eme ligne,
	on les additionne et
	on vérifie que ça vaut 12 */
ligneB_gr2(T) :-
	nth1(2, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	additions([A, B, C, D, E], R),
	R is 12.
						
/* On récupère les 5 membres de la 3eme ligne,
	on récupère les 3 membres de la 4ème colonne
	on en fait 2 nombres et
	on vérifie que le premier est un carré du second */
ligneC_gr2(T) :-
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
	est_carre(R1, R2).
						
/* On récupère les 4 membres de la 4eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneD_gr2(T) :-
	nth1(4, T, [_, B, C, D, E]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([B, C, D, E], R),
	carre(R).
					
/* On récupère les 3 membres de la 5eme ligne,
	on les multiplie et
	on vérifie que ça vaut 18 */
ligneE_gr2(T) :-
	nth1(5, T, [A, B, C, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 18.
				
/* On récupère les 3 membres de la 1ere colonne,
	on les multiplie et
	on vérifie que ça vaut 2 */
colonneA_gr2(T) :-
	nth1(1, T, [A, _, _, _, _]),
	nth1(2, T, [B, _, _, _, _]),
	nth1(3, T, [C, _, _, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	multiplications([A, B, C], R),
	R is 2.
				
/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est un palindrome */
colonneB_gr2(T) :-
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
	palindrome(R).
						
/* On récupère les 5 membres de la 3eme colonne,
	on récupère les 3 membres de la 5ème ligne,
	on en fait deux nombres et
	on vérifie que le premier est le carré du second */
colonneC_gr2(T) :-
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
	est_carre(R1, R2).
						
/* On récupère les 3 membres de la 4eme colonne,
	on les multiplie et
	on vérifie que ça vaut 12 */
colonneD_gr2(T) :-
	nth1(2, T, [_, _, _, B, _]),
	nth1(3, T, [_, _, _, C, _]),
	nth1(4, T, [_, _, _, D, _]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	multiplications([B, C, D], R),
	R is 12.
				
/* On récupère les 5 membres de la 5eme colonne,
	on récupère les 3 nombres de la 5ème ligne,
	on additionne les membres de la colonne,
	on fait un nombre avec ceux de la ligne et
	on vérifie que le premier est un diviseur premier du second */
colonneE_gr2(T) :-
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
	est_diviseur_premier(R, R2).
									

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
	writeln('Calcul en cours...'),
	gr3(T),
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
	afficher(T), !.
		
/* On récupère les 5 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
ligneA_gr3(T) :-
	nth1(1, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 4).
						
/* On récupère les 5 membres de la 2eme ligne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
ligneB_gr3(T) :-
	nth1(2, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	est_puissance(R, 2).
						
/* On récupère les 5 membres de la 3eme ligne,
	on en fait un nombre et
	on vérifie que c'est un cube */
ligneC_gr3(T) :-
	nth1(3, T, [A, B, C, D, E]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	between(0, 9, E),
	assembler([A, B, C, D, E], R),
	cube(R).
						
/* On récupère les 5 membres de la 4eme ligne,
	on récupère les 5 membres de la 5ème colonne
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
ligneD_gr3(T) :-
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
	R1 is R2.
										
/* On récupère les 4 membres de la 5eme ligne,
	on en fait un nombre et
	on vérifie que c'est un carré */
ligneE_gr3(T) :-
	nth1(5, T, [A, B, C, D, _]),
	between(0, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(1, 9, D),
	assembler([D, C, B, A], R),
	carre(R).
					
/* On récupère les 5 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 2 */
colonneA_gr3(T) :-
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
	est_puissance(R, 2).
						
/* On récupère les 5 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est une puissance de 4 */
colonneB_gr3(T) :-
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
	est_puissance(R, 4).
						
/* On récupère les 5 membres de la 3eme colonne,
	on en fait un nombre et
	on vérifie que c'est un cube */
colonneC_gr3(T) :-
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
	cube(R).
						
/* On récupère les 5 membres de la 4eme colonne,
	on récupère les 4 membres de la 5ème ligne,
	on additionne les membres de chacun et
	on vérifie que ces deux sommes sont égales */
colonneD_gr3(T) :-
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
	R1 is R2.
										
/* On récupère les 4 membres de la 5eme colonne,
	on en fait un nombre et
	on vérifie que c'est un carré */
colonneE_gr3(T) :-
	nth1(1, T, [_, _, _, _, A]),
	nth1(2, T, [_, _, _, _, B]),
	nth1(3, T, [_, _, _, _, C]),
	nth1(4, T, [_, _, _, _, D]),
	between(0, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	between(1, 9, D),
	assembler([D, C, B, A], R),
	carre(R).
					
/***********************
résolution grille exemple
 **********************/

/* Définition de la grille exemple */
grEx([L1, L2, L3, L4]) :-
	grEx_ligne(L1),
	grEx_ligne(L2),
	grEx_ligne(L3),
	grEx_ligne(L4).
grEx_ligne([_, _, _, _]).

/* méthode de résolution de la grille exemple */
resoudre_grEx(T) :- 
	writeln('Calcul en cours...'),
	grEx(T),
	ligneD_grEx(T),
	colonneC_grEx(T),	
	ligneB_grEx(T),
	ligneA_grEx(T),	
	colonneB_grEx(T),
	colonneA_grEx(T),		
	colonneD_grEx(T),
	ligneC_grEx(T),
	afficher(T), !.

/* On récupère les 2 membres de la 1ere ligne,
	on en fait un nombre et
	on vérifie que c'est le nombre qui précède 20 */
ligneA_grEx(T) :-
	nth1(1, T, [A, B, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	nombrePrecedent(20, R).																					

/* On récupère les 3 membres de la 2eme ligne,
	on en fait un nombre et
	on vérifie que c'est le nombre suivant 909 */
ligneB_grEx(T) :-
	nth1(2, T, [_, B, C, D]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	assembler([B, C, D], R),
	nombreSuivant(909,R).																			

/* On récupère les 2 membres de la 3eme ligne,
	on en fait un nombre et
	on vérifie qu'il possède 8 dizaines */
ligneC_grEx(T) :-
	nth1(3, T, [_, _, C, D]),
	between(1, 9, C),
	between(0, 9, D),
	assembler([ C, D], R),
	nombreAyantDizaine(8,R).	

/* On récupère les 3 membres de la 4eme ligne,
	on en fait un nombre et
	on vérifie qu'il possède le même chiffre aux centaines et aux unités (palindrome)*/
ligneD_grEx(T) :-
	nth1(4, T, [A, B, C, _]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	assembler([A, B, C], R),
	palindrome(R).

/* On récupère les 2 membres de la 1ere colonne,
	on en fait un nombre et
	on vérifie que c'est 20+15 */
colonneA_grEx(T) :-
	nth1(3, T, [C, _, _, _]),
	nth1(4, T, [D, _, _, _]),
	between(1, 9, C),
	between(0, 9, D),
	assembler([C, D], R),
	calculer([20,15],[+],R).																						

/* On récupère les 2 membres de la 2eme colonne,
	on en fait un nombre et
	on vérifie que c'est celui qui précède 100 */
colonneB_grEx(T) :-
	nth1(1, T, [_, A, _, _]),
	nth1(2, T, [_, B, _, _]),
	between(1, 9, A),
	between(0, 9, B),
	assembler([A, B], R),
	nombrePrecedent(100,R).																						

/* On récupère les 3 membres de la 3eme colonne,
	on en fait un nombre et
	on vérifie que c'est 100+50+30+5 */
colonneC_grEx(T) :-
	nth1(2, T, [_, _, B, _]),
	nth1(3, T, [_, _, C, _]),
	nth1(4, T, [_, _, D, _]),
	between(1, 9, B),
	between(0, 9, C),
	between(0, 9, D),
	assembler([B, C, D], R),
	calculer([100,50,30,5],[+,+,+],R).	

/* On récupère les 3 membres de la 4eme colonne,
	on en fait un nombre
	on vérifie que c'est (50*2)+5 */
colonneD_grEx(T) :-
	nth1(1, T, [_, _, _, A]),
	nth1(2, T, [_, _, _, B]),
	nth1(3, T, [_, _, _, C]),
	between(1, 9, A),
	between(0, 9, B),
	between(0, 9, C),
	assembler([A,B,C],R),
	calculer([50,2,5],[*,+],R).