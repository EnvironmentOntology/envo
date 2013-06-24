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
        gaz_envo(I,C,_).

gaz_envo(I,C,CN):-
        class(I,INx),
        id_idspace(I,'GAZ'),
        downcase_atom(INx,IN),
        concat_atom(Toks,' ',IN),
        tsub(Toks,SubToks),
        concat_atom(SubToks,' ',CN),
        entity_label_override(C,CN),
        valid_envo(C).

tsub(Toks,SubToks) :-
        append(SubToks,[_|_],Toks).
tsub(Toks,SubToks) :-
        append([_|_],SubToks,Toks).


zzzgaz_envo(I,C,CN):-
        class(I,INx),
        downcase_atom(INx,IN),
        id_idspace(I,'GAZ'),
        envo_name(C,CN),
        (   ends_with(IN,CN)
        ;   starts_with(IN,CN)).

gaz_envo_best(I,C) :-
        gaz_envo(I,C,CN),
        \+ ((gaz_envo(I,C2,CN2),
             C2\=C,
             atom_length(CN,Len1),
             atom_length(CN2,Len2),
             Len2 > Len1)).

        

ends_with(X,Y) :-
        atom_concat(_,Y,X), % quick
        atom_concat(' ',Y,Spc_Y),
        atom_concat(_,Spc_Y,X).
starts_with(X,Y) :-
        atom_concat(Y,_,X), % quick
        atom_concat(Y,' ',Y_Spc),
        atom_concat(Y_Spc,_,X).


        
envo_name(C,CN) :-
        class(C),
        id_idspace(C,'ENVO'),
        entity_label_override(C,CN),
        valid_envo(C).

        
valid_envo(X) :- \+ \+ subclassT(X,'ENVO:00000000'),!.  % geographic feature

        


/*

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo/2 -label -no_pred 

  blip-findall  -r envo -r gaz -consult mine_links.pro   gaz_envo_best/2 -label -no_pred 
  
  */

