
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).

palindrome(X) :- number_chars(X, L), reverse(L, R), compare(=, L, R).

inverse(N, I) :- N<0, I is (N*(-1)); N>=0, I is N.

cube(N) :- inverse(N, I), P is 1 rdiv 3,  C is round(I**P), I =:= C^3.

/** TODO **/

/** CALCULER -> Liste(s) + Récursivité **/

addition([X,Y| T1], T) :- R is X+Y, append([R],T1,T).
soustraction([X,Y| T1], T) :- R is X-Y, append([R],T1,T).
multiplication([X,Y| T1], T) :- R is X*Y, append([R],T1,T).
division([X,Y| T1], T) :- R is X/Y, append([R],T1,T).


/* Calcul (sachant que la liste est dans le bonne ordre ) */
calculer([x], [], 0).
calculer([X,Y| _], [A|T2], R) :- 
	nth0(0, [A], +), addition([X, Y], T1),        calculer(T1, T2, R);  
	nth0(0, [A], -), soustraction([X, Y], T1),    calculer(T1, T2, R);
	nth0(0, [A], *), multiplication([X, Y], T1),  calculer(T1, T2, R);
	nth0(0, [A], /), division([X, Y], T1),        calculer(T1, T2, R);
	length([A|T2], 0), R is [X].
	
