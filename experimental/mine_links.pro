:- use_module(bio(ontol_db)).
:- use_module(bio(metadata_db)).

all:-
        add_envo_is_a,
        rewrite_is_a.

% Lake Nyar
add_envo_is_a:-
        forall(   (restriction(C,located_in,_),
                   \+ subclass(C,_),
                   \+ subclass(_,C),
                   type_from_name(C,SC)),
                  assert(ontol_db:subclass(C,SC))).

rewrite_is_a:-
        forall((subclass(Inst,Class),\+subclass(_,Inst)),
               (   
                   retractall(ontol_db:subclass(Inst,Class)),
                   assert(ontol_db:inst_of(Inst,Class)),
                   retractall(ontol_db:class(Inst)),
                   assert(ontol_db:inst(Inst)))).

true_class(C) :-
        class(C),
        \+ \+ subclass(_,C),
        \+ restriction(C,_,_),
        \+ ((parentT(C,R,_),
             R\=subclass)).

%% entity_label_override(?,+) is semidet
entity_label_override('ENVO:00000081',mount,1) :- !.   % mountain
entity_label_override(E,N,1) :- entity_label(E,N),!.
%% entity_label_override(E,N,0.9) :- entity_label_or_exact_synonym(E,N),!.

gaz_envo(I,C):-
        gaz_envo(I,C,_,_).

% rules
gaz_envo(I,C,CN,25):-
        class(I,INx),
        atom_concat(_,' Trench',INx),
        is_oceanic(I),
        CN='ocean trench',
        class(C,CN).
% generic
gaz_envo(I,C,CN,Score):-
        class(I,INx),
        id_idspace(I,'GAZ'),
        downcase_atom(INx,IN),
        concat_atom(Toks,' ',IN),
        tsub(Toks,SubToks,LenScore),
        concat_atom(SubToks,' ',CN),
        entity_label_override(C,CN,SynScore),
        Score is LenScore + SynScore,
        valid_envo(C).

% city of X ==> city
tsub(Toks,SubToks,S) :-
        append(SubToks,[of|_],Toks),
        length(SubToks,Len),
        S is 5+Len*3.
% glacier bay ==> glacier
tsub(Toks,SubToks,S) :-
        append(SubToks,[_|_],Toks),
        length(SubToks,Len),
        S is Len*3.
% glacier bay ==> bay
tsub(Toks,SubToks,S) :-
        append([_|_],SubToks,Toks),
        length(SubToks,Len),
        S is 1+Len*3.


gaz_envo_best(I,C) :-
        gaz_envo(I,C,CN,S1x),
        term_score(C,CN,S1y),
        S1 is S1x + S1y,
        \+ ((gaz_envo(I,C2,CN2,S2x),
             term_score(C2,CN2,S2y),
             S2 is S2x + S2y,
             S2 > S1)).

term_score(C,_N,S) :-
        (   subclassT(C,'ENVO:00000002') % anthropogenic feature
        ->  S=1.5
        ;   S=1).

% 31 = wadi
valid_envo(X) :- X\='ENVO:00000031', \+ \+ subclassT(X,'ENVO:00000000'),!.  % geographic feature

is_oceanic(I) :-
        parentT(I,'GAZ:00000590').
% foo('0').

        


/*

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo/2 -label -no_pred 

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo_best/2 -label -no_pred 
  
  */

