
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

inverse(N, I) :- N<0, I is (N*(-1)); N>=0, I is N.

cube(N) :- inverse(N, I), P is 1 rdiv 3,  C is round(I**P), I =:= C^3.

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
