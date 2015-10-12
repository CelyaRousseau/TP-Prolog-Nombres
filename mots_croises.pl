
/** REGLES MATHEMATIQUES **/
nombrePrecedent(X, P) :- P is X - 1.

nombreSuivant(X, S) :- S is X + 1.

nombreAyantDizaine(X, N) :- Low is X*10, High is X*10+9, between(Low, High, N).


/** TODO **/

/** CALCULER -> Liste(s) + Récursivité **/ 
/** CUBE **/
/** PALINDROME **/