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


entity_label_override('ENVO:00000081',mount) :- !.   % mountain
entity_label_override(E,N) :- entity_label(E,N).


% Lake Nyar
%% type_from_name('GAZ:nnn','ENVO:nnn')
type_from_name(C,SC):-
        entity_label(C,N),
        downcase_atom(N,Nd),
        concat_atom([SCN|_],' ',Nd),
        entity_label_override(SC,SCN),
        debug(gaz,'~w < ~w',[N,SCN]).

type_from_name(C,SC):-
        entity_label(C,N),
        downcase_atom(N,Nd),
        concat_atom(Toks,' ',Nd),
        reverse(Toks,[SCN|_]),
        entity_label_override(SC,SCN),
        debug(gaz,'~w < ~w',[N,SCN]).

gaz_envo(I,C):-
        gaz_envo(I,C,_,Score).

gaz_envo(I,C,CN,Score):-
        class(I,INx),
        id_idspace(I,'GAZ'),
        downcase_atom(INx,IN),
        concat_atom(Toks,' ',IN),
        tsub(Toks,SubToks,Score),
        concat_atom(SubToks,' ',CN),
        entity_label_override(C,CN),
        valid_envo(C).

% city of X ==> city
tsub(Toks,SubToks,5) :-
        append(SubToks,[of|_],Toks).
% glacier bay ==> glacier
tsub(Toks,SubToks,1) :-
        append(SubToks,[_|_],Toks).
% glacier bay ==> bay
tsub(Toks,SubToks,2) :-
        append([_|_],SubToks,Toks).


gaz_envo_best(I,C) :-
        gaz_envo(I,C,CN,S1x),
        term_score(C,CN,S1y),
        S1 is S1x + S1y,
        \+ ((gaz_envo(I,C2,CN2,S2x),
             term_score(C2,CN2,S2y),
             S2 is S2x + S2y,
             S2 > S1)).

term_score(C,N,S) :-
        atom_length(N,Len),
        (   subclassT(C,'ENVO:00000002') % anthropogenic feature
        ->  Mod=5
        ;   Mod=1),
        S is Len + Mod.

        
        
valid_envo(X) :- \+ \+ subclassT(X,'ENVO:00000000'),!.  % geographic feature

        


/*

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo/2 -label -no_pred 

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo_best/2 -label -no_pred 
  
  */

