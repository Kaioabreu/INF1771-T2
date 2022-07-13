:- dynamic return_right_answer_ramo/2.
	return_right_answer_ramo("Eh um mamifero?", "Tem listras?").
	return_right_answer_ramo("Eh uma ave?", "Ele voa?").

:- dynamic return_for_wrong_answer_ramo/2.
	return_for_wrong_answer_ramo("Eh um mamifero?", "Eh uma ave?").

:- dynamic return_right_answer_folha/2.
	return_right_answer_folha("Tem listras?", "zebra").
	return_right_answer_folha("Ele voa?", "aguia").

:- dynamic return_for_wrong_answer_folha/2.
	return_for_wrong_answer_folha("Eh uma ave?", "lagarto").
	return_for_wrong_answer_folha("Tem listras?", "leao").
	return_for_wrong_answer_folha("Ele voa?", "pinguin").
	return_for_wrong_answer_folha("Eh um passaro?", "lagarto").


folha(Ramo, Folha) :-
    write("Pergunta: "), write(Ramo), write(" (s./ n.)"), nl,
    read(Input), nl,
    (
		(Input=n, return_for_wrong_answer_ramo(Ramo, NovoRamo), folha(NovoRamo, Folha));
        (Input=n, not(return_for_wrong_answer_ramo(Ramo, _)), return_for_wrong_answer_folha(Ramo, Folha));
        (Input=s, return_right_answer_ramo(Ramo, NovoRamo), folha(NovoRamo, Folha));
        (Input=s, not(return_right_answer_ramo(Ramo, _)), return_right_answer_folha(Ramo, Folha))
    ).


start_game :-
    folha("Eh um mamifero?", RespostaPossivel),
	write("Seu animal eh "), write(RespostaPossivel), write("? (s./n.)"), nl,
    read(Acertei), nl,
    (
        (Acertei=s, write("Adivinhei!"), nl, write("Obrigado por jogar!"), nl);
        (Acertei=n, write("Errei!"), nl, write("Qual era o seu animal? (Digite o nome entre aspas)"), nl,
			read(NovoAnimal),

			write("Como diferenciar '"), write(RespostaPossivel), write("' de '"), write(NovoAnimal), write("'? (Digite uma pergunta entre aspas)"), nl, read(NovaPergunta),
			write("Qual a resposta de '"), write(NovaPergunta), write("' para '"), write(NovoAnimal), write("'? (s./n.)"), nl, read(NovaResposta),
			(

				(
					return_right_answer_folha(RamoAntigo, RespostaPossivel), 			
					retract(return_right_answer_folha(RamoAntigo, RespostaPossivel)), /*Remove elemento da tabela*/  
					assertz(return_right_answer_ramo(RamoAntigo, NovaPergunta))  
				);                                                  

				(
					return_for_wrong_answer_folha(RamoAntigo, RespostaPossivel),                 
					retract(return_for_wrong_answer_folha(RamoAntigo, RespostaPossivel)), /*Remove elemento da tabela*/      
					assertz(return_for_wrong_answer_ramo(RamoAntigo, NovaPergunta))     
				)
			),
			(
				(
					NovaResposta=n,                              
					assertz(return_for_wrong_answer_folha(NovaPergunta, NovoAnimal)),  
					assertz(return_right_answer_folha(NovaPergunta, RespostaPossivel))         
				);
				(
					NovaResposta=s,                               
					assertz(return_right_answer_folha(NovaPergunta, NovoAnimal)),   
					assertz(return_for_wrong_answer_folha(NovaPergunta, RespostaPossivel))       
				)                                               
				
			)
		)
    ),
    write("Jogar novamente? (s./n.): "), nl,
    read(PlayAgain),
    (   
		(PlayAgain=n, nl, !, fail);
        (PlayAgain=s, nl, start_game, !, fail)
        
    ).