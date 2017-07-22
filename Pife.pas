program pife;
	
	var	i, j, k,	// variáveis auxiliares
		ncrt: integer;	// número de cartas no baralho
		j1, j2: array[1..10] of integer;	// cartas do jogador 1 (usuário) e do jogador 2 (a CPU)
		baralho: array[1..104] of integer;	// 2 baralhos de 52 cartas
		v1, v2: integer;	// número de vitórias de cada jogador
		desc,	// a carta que está no descarte
		desc_ant: integer;	// a carta embaixo do descarte
		tcl: char;	// para ler uma tecla pressionada
		mostrar: boolean;	// jogar vendo as cartas do computador e seu numero de trincas
	
	function valor(carta: integer): integer;
		// recebe como parâmetro uma carta (de 1 a 104)
		// retorna o valor dessa carta (de 1 a 13)
		begin
			if (carta mod 13)=0 then
				valor:=13
			else
				valor:=carta mod 13;
		end;
	
	function naipe(carta: integer): integer;
		// recebe como parâmetro uma carta (de 1 a 104)
		// retorna o naipe dessa carta (0, 1, 2 ou 3)
		begin
			naipe:=((carta-1) mod 52) div 13;
		end;
	
	function par(carta1, carta2: integer): boolean;
		// recebe como parâmetros duas cartas (de 1 a 104)
		// retorna true somente se as cartas formam um par
		
		var	valor1, naipe1, valor2, naipe2: integer;
		
		begin
			
			valor1:=valor(carta1);
			naipe1:=naipe(carta1);
			valor2:=valor(carta2);
			naipe2:=naipe(carta2);
			
			if
			(
				((valor1=valor2) and (naipe1<>naipe2))	// valores iguais e naipes diferentes
				or
				(
					(naipe1=naipe2)
					and
					(
						(valor1=(valor2+1)) or (valor1=(valor2+2))	// naipes iguais e valores crescentes
						or (valor1=(valor2-1)) or (valor1=(valor2-2))	// ex.: 5 e 6 ou 5 e 7
						or ((valor1=1) and ((valor2=12) or (valor2=13)))	// o ás pode valer 14
						or ((valor2=1) and ((valor1=12) or (valor1=13)))	// ex.: A e Q ou A e K
					)
				)
			)
			then
				par:=true
			else
				par:=false;
		end;
	
	
	function ntrinca(carta1, carta2, carta3, carta4, carta5, carta6, carta7, carta8, carta9: integer): integer;
		// recebe como parâmetros 9 cartas (de 1 a 104)
		// retorna a quantidade de trincas formadas pelas cartas
		
		var	i1,i2,i3,i4,i5,i6,i7,i8,i9: integer;
			carta: array[1..9] of integer;
			n: integer;
		
		begin
			
			carta[1]:=carta1;
			carta[2]:=carta2;
			carta[3]:=carta3;
			carta[4]:=carta4;
			carta[5]:=carta5;
			carta[6]:=carta6;
			carta[7]:=carta7;
			carta[8]:=carta8;
			carta[9]:=carta9;
			
			n:=0;
			for i1:=1 to 9 do
			begin
				for i2:=i1+1 to 9 do
				begin
					if par(carta[i1],carta[i2]) then
					begin
						for i3:=i2+1 to 9 do
						begin
							// 1ª trinca
							if par(carta[i3],carta[i1]) and par(carta[i3],carta[i2]) then
							begin
								n:=1;
								//
								for i4:=1 to 9 do
								begin
									if (i4<>i1) and (i4<>i2) and (i4<>i3) then
									begin
										for i5:=i4+1 to 9 do
										begin
											if (i5<>i1) and (i5<>i2) and (i5<>i3) and par(carta[i4],carta[i5]) then
											begin
												for i6:=i5+1 to 9 do
												begin
													// 2ª trinca
													if (i6<>i1) and (i6<>i2) and (i6<>i3) and par(carta[i6],carta[i5]) and par(carta[i6],carta[i4]) then
													begin
														n:=2;
														//
														for i7:=1 to 9 do
														begin
															if (i7<>i1) and (i7<>i2) and (i7<>i3) and (i7<>i4) and (i7<>i5) and (i7<>i6) then
															begin
																for i8:=i7+1 to 9 do
																begin
																	if (i8<>i1) and (i8<>i2) and (i8<>i3) and (i8<>i4) and (i8<>i5) and (i8<>i6) and par(carta[i7],carta[i8]) then
																	begin
																		for i9:=i8+1 to 9 do
																		begin
																			// 3ª trinca
																			if (i9<>i1) and (i9<>i2) and (i9<>i3) and (i9<>i4) and (i9<>i5) and (i9<>i6) and par(carta[i9],carta[i7]) and par(carta[i9],carta[i8]) then
																			begin
																				//
																				n:=3;
																				break;
																				//
																			end;
																			if n=3 then
																				break;
																		end;
																	end;
																	if n=3 then
																		break;
																end;
															end;
															if n=3 then
																break;
														end;
														//
													end;
													if n=3 then
														break;
												end;
											end;
											if n=3 then
												break;
										end;
									end;
									if n=3 then
										break;
								end;
								//
							end;
							if n=3 then
								break;
						end;
					end;
					if n=3 then
						break;
				end;
				if n=3 then
					break;
			end;
			
			ntrinca:=n;
		end;
		
	procedure dsncrt(carta, x, y: integer; virada: boolean);
		// esta procedure é responsável por desenhar uma carta na tela
		// recebe como parâmetros a carta que será desenhada e a posição (x,y)
		// virada=true indica que a carta será desenhada com a face para cima
		// virada=falsee indica que a carta será desenhada com a face para baixo
		const tex=#197;	// textura do verso das cartas
		var	v: string[2];	// valor
			n: char;	// naipe
		begin
			
			textbackground(7);
			
			if virada then
			begin
				
				textcolor(0);
				
				gotoxy(x,y);	write('     ');
				gotoxy(x,y+1);	write('     ');
				gotoxy(x,y+2);	write('     ');
				gotoxy(x,y+3);	write('     ');
				gotoxy(x,y+4);	write('     ');
			
				if valor(carta)=1 then
					v:='A'
				else
					if valor(carta)=11 then
						v:='J'
					else
						if valor(carta)=12 then
							v:='Q'
						else
							if valor(carta)=13 then
								v:='K'
							else
								str(valor(carta),v);
				
				n:=chr(naipe(carta)+3);
				
				if naipe(carta) <=1 then
					textcolor(12);
				
				gotoxy(x+1,y+1);
				write(v);
				
				gotoxy(x+1,y+2);
				write(n);
				
			end
			else
			begin
				
				if carta<=52 then
					textcolor(1)	// cartas azuis
				else
					textcolor(4);	// cartas vermelhas
				
				gotoxy(x,y);	write(#218,#194,#194,#194,#191);
				gotoxy(x,y+1);	write(#195,#197,#197,#197,#180);
				gotoxy(x,y+2);	write(#195,#197,#197,#197,#180);
				gotoxy(x,y+3);	write(#195,#197,#197,#197,#180);
				gotoxy(x,y+4);	write(#192,#193,#193,#193,#217);
				
			end;
			
		end;
	
	procedure apgcrt(x,y: integer);
		// apaga uma carta dada sua posição
		begin
			textbackground(2);
			gotoxy(x,y);	write('     ');
			gotoxy(x,y+1);	write('     ');
			gotoxy(x,y+2);	write('     ');
			gotoxy(x,y+3);	write('     ');
			gotoxy(x,y+4);	write('     ');
		end;
	
	procedure msg(mensagem: string);
		// recebe como parâmetro uma string
		// imprime essa string no canto inferior esquerdo da janela
		begin
			textbackground(2);
			textcolor(0);
			gotoxy(3,24);
			write('                                            ');
			gotoxy(3,24);
			write(mensagem);
		end;
	
	function descarte: integer;
		// Módulo de Inteligência Artificial que retorna a posição da carta que o computador "deseja" descartar
		var	maior, h, g, n: integer;
			pt: array[1..10] of integer;
			m: array[1..10] of integer;
		begin
			
			for i:=1 to 10 do
			begin
				
				for j:=1 to 10 do
					m[j]:=j2[j];
				
				for j:=i to 9 do
					m[j]:=m[j+1];
				
				pt[i]:=ntrinca(m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9]);
				
			end;
			
			maior:=pt[1];
			for i:=2 to 10 do
				if pt[i]>maior then
					maior:=pt[i];
			
			n:=0;
			for i:=1 to 10 do
				if pt[i]=maior then
					n:=n+1;
			
			if n=1 then
			begin
				for i:=1 to 10 do
				begin
					if pt[i]=maior then
					begin
						descarte:=i;
						break;
					end;
				end;
			end
			else
			begin
				for i:=1 to 10 do
				begin
					if pt[i]=maior then
					begin
						for j:=1 to 9 do
						begin
							if j<>i then
							begin
								for h:=j+1 to 10 do
								begin
									if (h<>i) and par(j2[j],j2[h]) then
									begin
										
										for g:=1 to ncrt do
										begin
											if par(baralho[g],j2[j]) and par(baralho[g],j2[h]) then
												pt[i]:=pt[i]+1;
										end;
										
										for g:=1 to 9 do
											if par(j1[g],j2[j]) and par(j1[g],j2[j]) then
												pt[i]:=pt[i]+1;
										
									end;
								end;
							end;
						end;
					end;
				end;
				
				maior:=pt[1];
				for i:=2 to 10 do
					if pt[i]>maior then
						maior:=pt[i];
				
				n:=0;
				for i:=1 to 10 do
					if pt[i]=maior then
						n:=n+1;
				
				//if n=1 then
				//begin
					for i:=1 to 10 do
					begin
						if pt[i]=maior then
						begin
							descarte:=i;
							break;
						end;
					end;
				//end
				//else
				//begin
				//end;
				
			end;
			
		end;
	
	function pegdesc: boolean;
		// Módulo de Inteligência Artificial que retorna true se o computador "deseja" pegar o descarte
		var	retorno: boolean;
			m: array[1..9] of integer;
			com, sem: integer;
		begin
			
			pegdesc:=false;
			
			for j:=1 to 9 do
				m[j]:=j2[j];
				
			sem:=ntrinca(m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9]);
			
			for i:=1 to 9 do
			begin
				
				m[i]:=desc;
				
				com:=ntrinca(m[1],m[2],m[3],m[4],m[5],m[6],m[7],m[8],m[9]);
				
				if com>sem then
				begin
					pegdesc:=true;
					break;
				end;
				
				m[i]:=j2[i];
				
			end;
			
		end;
	
	procedure orgcrt;
		// organiza as cartas do computador quando ele vence
		// separa as trincas e as coloca em ordem crescente
		var	i1,i2,i3,i4,i5,i6,i7,i8,i9: integer;
			carta: array[1..9] of integer;
			n: integer;
		
		begin
			
			carta[1]:=j2[1];
			carta[2]:=j2[2];
			carta[3]:=j2[3];
			carta[4]:=j2[4];
			carta[5]:=j2[5];
			carta[6]:=j2[6];
			carta[7]:=j2[7];
			carta[8]:=j2[8];
			carta[9]:=j2[9];
			
			n:=0;
			for i1:=1 to 9 do
			begin
				for i2:=i1+1 to 9 do
				begin
					if par(carta[i1],carta[i2]) then
					begin
						for i3:=i2+1 to 9 do
						begin
							// 1ª trinca
							if par(carta[i3],carta[i1]) and par(carta[i3],carta[i2]) then
							begin
								n:=1;
								
								j2[1]:=carta[i1];
								j2[2]:=carta[i2];
								j2[3]:=carta[i3];
																				
								//
								for i4:=1 to 9 do
								begin
									if (i4<>i1) and (i4<>i2) and (i4<>i3) then
									begin
										for i5:=i4+1 to 9 do
										begin
											if (i5<>i1) and (i5<>i2) and (i5<>i3) and par(carta[i4],carta[i5]) then
											begin
												for i6:=i5+1 to 9 do
												begin
													// 2ª trinca
													if (i6<>i1) and (i6<>i2) and (i6<>i3) and par(carta[i6],carta[i5]) and par(carta[i6],carta[i4]) then
													begin
														n:=2;
														
														j2[4]:=carta[i4];
														j2[5]:=carta[i5];
														j2[6]:=carta[i6];
																				
														//
														for i7:=1 to 9 do
														begin
															if (i7<>i1) and (i7<>i2) and (i7<>i3) and (i7<>i4) and (i7<>i5) and (i7<>i6) then
															begin
																for i8:=i7+1 to 9 do
																begin
																	if (i8<>i1) and (i8<>i2) and (i8<>i3) and (i8<>i4) and (i8<>i5) and (i8<>i6) and par(carta[i7],carta[i8]) then
																	begin
																		for i9:=i8+1 to 9 do
																		begin
																			// 3ª trinca
																			if (i9<>i1) and (i9<>i2) and (i9<>i3) and (i9<>i4) and (i9<>i5) and (i9<>i6) and par(carta[i9],carta[i7]) and par(carta[i9],carta[i8]) then
																			begin
																				//
																				n:=3;
																				j2[7]:=carta[i7];
																				j2[8]:=carta[i8];
																				j2[9]:=carta[i9];
																				break;
																				//
																			end;
																			if n=3 then
																				break;
																		end;
																	end;
																	if n=3 then
																		break;
																end;
															end;
															if n=3 then
																break;
														end;
														//
													end;
													if n=3 then
														break;
												end;
											end;
											if n=3 then
												break;
										end;
									end;
									if n=3 then
										break;
								end;
								//
							end;
							if n=3 then
								break;
						end;
					end;
					if n=3 then
						break;
				end;
				if n=3 then
					break;
			end;
		
			// valores em sequência, naipes iguais
			i:=0;
			repeat
				if naipe(j2[i+1])=naipe(j2[i+2]) then
				begin
					if valor(j2[i+1])>valor(j2[i+2]) then
					begin
						k:=j2[i+1];
						j2[i+1]:=j2[i+2];
						j2[i+2]:=k;
					end;
					if valor(j2[i+1])>valor(j2[i+3]) then
					begin
						k:=j2[i+1];
						j2[i+1]:=j2[i+3];
						j2[i+3]:=k;
					end;
					if valor(j2[i+2])>valor(j2[i+3]) then
					begin
						k:=j2[i+2];
						j2[i+2]:=j2[i+3];
						j2[i+3]:=k;
					end;
					
					// QKA
					if (valor(j2[i+1])=1) and (valor(j2[i+3])=13) then
					begin
						k:=j2[i+1];
						j2[i+1]:=j2[i+3];
						j2[i+3]:=k;
						
						k:=j2[i+1];
						j2[i+1]:=j2[i+2];
						j2[i+2]:=k;
					end;
				end;
				
				i:=i+3;
			until i=9;
		end;
	
	function lertcl: char;
		var tecla: char;
		begin
			tecla:=readkey;
			if tecla=#94 then	// alternar entre mostrar e não mostrar as cartas do computador
			begin
				mostrar:=not(mostrar);
				
				gotoxy(52,8);
				textbackground(2);
				textcolor(0);
				
				if mostrar then
					write('Trincas: ',ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9]))
				else
					write('          ');
				
				for i:=1 to 9 do
					dsncrt(j2[i],6*i-3,2,mostrar);
			end;
			
			textbackground(2);
			textcolor(14);
			gotoxy(63,25);
		end;

	
	Begin	// início do programa principal
		
	   textbackground(2);
	   clrscr;
	   textcolor(0);

	   
	   i:=17;	//17
	   j:=6;	//9
	   
	   gotoxy(i,j);
	   write(#219,#219,#219,#219,#219,#219,#32,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#32,#219,#219,#219);
	   gotoxy(i,j+1);
	   write(#32,#219,#219,#32,#32,#219,#219,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#219,#219,#32,#219,#219);
	   gotoxy(i,j+2);
	   write(#32,#219,#219,#32,#32,#219,#219,#32,#32,#32,#32,#32,#32,#32,#32,#32,#32,#219,#219);
	   gotoxy(i,j+3);
	   write(#32,#219,#219,#32,#32,#219,#219,#32,#32,#219,#219,#219,#219,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#32,#32,#219,#219,#219,#219);
	   gotoxy(i,j+4);
	   write(#32,#219,#219,#219,#219,#219,#32,#32,#32,#32,#32,#219,#219,#32,#32,#32,#219,#219,#219,#219,#219,#32,#32,#32,#219,#219,#32,#32,#219,#219);
	   gotoxy(i,j+5);
	   write(#32,#219,#219,#32,#32,#32,#32,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#32,#219,#219,#219,#219,#219,#219);
	   gotoxy(i,j+6);
	   write(#32,#219,#219,#32,#32,#32,#32,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#32,#219,#219);
	   gotoxy(i,j+7);
	   write(#32,#219,#219,#32,#32,#32,#32,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#219,#219,#32,#32,#32,#32,#32,#219,#219,#32,#32,#219,#219);
	   gotoxy(i,j+8);
	   write(#219,#219,#219,#219,#32,#32,#32,#32,#32,#219,#219,#219,#219,#219,#219,#32,#219,#219,#219,#219,#32,#32,#32,#32,#32,#219,#219,#219,#219);
	   
	   //---
	   gotoxy(i,j + 10);
	   write('Versão 1.0');
	   
	   gotoxy(i,j + 14);
	   write('Desenvolvido por Adarlan Alves');
	   
	   gotoxy(63,25);
	   readkey;
	   //---
	   
	   v1:=0;
	   v2:=0;
	   mostrar:=false;
	   
	   repeat
		textbackground(2);
		clrscr;
		
		textcolor(0);
		
		gotoxy(5,8);
		write(v2);
		
		gotoxy(5,16);
		write(v1);
			
		for i:=1 to 104 do
			baralho[i]:=0;
		
		// embaralhar
		for i:=1 to 104 do	// para cada carta de 1 a 104...
		begin
			repeat
				j:=random(104)+1;	// ... definir uma posição aleatória
			until baralho[j]=0;	// desde que essa posiçãoo esteja vazia...
			baralho[j]:=i;	// ... a carta será colocada nela
		end;
		
		ncrt:=104;	// inicialmente há 104 cartas no baralho
		dsncrt(baralho[ncrt],24,10,false);
		gotoxy(63,25);
		delay(30);
		
		// dar as cartas
		for i:=1 to 9 do	// 9 cartas
		begin
			j1[i]:=baralho[ncrt];	// a carta da última posição é dada ao jogador 1
			ncrt:=ncrt-1;	// o número de cartas no baralho é decrementada
			dsncrt(j1[i],6*i-3,18,true);
			
			dsncrt(baralho[ncrt],24,10,false);
			gotoxy(63,25);
			delay(30);
			
			j2[i]:=baralho[ncrt];
			ncrt:=ncrt-1;
			dsncrt(j2[i],6*i-3,2,mostrar);
			
			dsncrt(baralho[ncrt],24,10,false);
			gotoxy(63,25);
			delay(30);
		end;
		
		desc:=0;
		
		i:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9]);
		textbackground(2);
		textcolor(0);
		gotoxy(52,24);
		write('Trincas: ',i);
		
		gotoxy(52,8);
		if mostrar then
			write('Trincas: ',ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9]));
		
		msg('Pegue uma carta no baralho');
		
		textcolor(14);	// desenhar seleção no baralho
		gotoxy(23,9);	write(#218,'     ',#191);
		gotoxy(23,15);	write(#192,'     ',#217);
		
		gotoxy(63,25);
		
		repeat
			tcl:=lertcl;
		until tcl=#13;
		
		gotoxy(23,9);	write('       ');
		gotoxy(23,15);	write('       ');
		
		j1[10]:=baralho[ncrt];
		ncrt:=ncrt-1;
		dsncrt(baralho[ncrt],24,10,false);
		dsncrt(j1[10],57,18,true);
		
		i:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9]);
		
		j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[6],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[3],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[2],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[1],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
		j:=ntrinca(j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
		if j>i then i:=j;
	
		textbackground(2);
		textcolor(0);
		gotoxy(52,24);
		write('Trincas: ',i);
		
		repeat
			msg('Descarte uma de suas cartas');
			
			textbackground(2);
			textcolor(14);	// desenhar seleção na posição 10
			gotoxy(56,17);	write(#218,'     ',#191);
			gotoxy(56,23);	write(#192,'     ',#217);
			
			k:=10;
			
			repeat
				
				gotoxy(63,25);
				tcl:=lertcl;
				
				textbackground(2);
				gotoxy(6*k-4,17);	write('       ');
				gotoxy(6*k-4,23);	write('       ');
				
				if (tcl=#75) and (k>1) then
					k:=k-1;
				if (tcl=#77) and (k<10) then
					k:=k+1;
				
				if (tcl=#115) and (k>1) then
				begin
					i:=j1[k];
					j1[k]:=j1[k-1];
					j1[k-1]:=i;
					dsncrt(j1[k],6*k-3,18,true);
					dsncrt(j1[k-1],6*(k-1)-3,18,true);
					k:=k-1;
				end;
				if (tcl=#116) and (k<10) then
				begin
					i:=j1[k];
					j1[k]:=j1[k+1];
					j1[k+1]:=i;
					dsncrt(j1[k],6*k-3,18,true);
					dsncrt(j1[k+1],6*(k+1)-3,18,true);
					k:=k+1;
				end;
				
				textbackground(2);
				textcolor(14);
				gotoxy(6*k-4,17);	write(#218,'     ',#191);
				gotoxy(6*k-4,23);	write(#192,'     ',#217);
				
				if tcl=#13 then
					break;
				
			until false;
			
			gotoxy(6*k-4,17);	write('       ');
			gotoxy(6*k-4,23);	write('       ');
			
			desc_ant:=desc;
			
			desc:=j1[k];
			apgcrt(6*k-3,18);
			dsncrt(desc,36,10,true);
			
			msg('');
			for i:=k+1 to 10 do
			begin
				j1[i-1]:=j1[i];
				gotoxy(63,25);
				delay(40);
				apgcrt(6*i-3,18);
				dsncrt(j1[i-1],6*(i-1)-3,18,true);
			end;
			
			i:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9]);
			textbackground(2);
			textcolor(0);
			gotoxy(52,24);
			write('Trincas: ',i);
			if i=3 then
			begin
				msg('Você é o vencedor!');
				v1:=v1+1;
				textcolor(0);
				gotoxy(5,16);
				write(v1);
				break;
			end;
			
			msg('Aguarde a máquina jogar');
			
			gotoxy(63,25);
			delay(300);
			if pegdesc then	// pegar carta no descarte
			begin
				j2[10]:=desc;
				desc:=desc_ant;
				if desc=0 then
					apgcrt(36,10)
				else
					dsncrt(desc,36,10,true);
			end
			else
			begin
				j2[10]:=baralho[ncrt];
				ncrt:=ncrt-1;
				dsncrt(baralho[ncrt],24,10,false);
			end;
			dsncrt(j2[10],57,2,mostrar);
			
			if mostrar then
			begin
				i:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9]);
				
				j:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[3],j2[4],j2[6],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[3],j2[5],j2[6],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[2],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[1],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
				j:=ntrinca(j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9],j2[10]);
				if j>i then i:=j;
	     		
				textbackground(2);
				textcolor(0);
				gotoxy(52,8);
				write('Trincas: ',i);
			end;
			
			gotoxy(63,25);
			delay(300);
			
			k:=descarte;
			
			desc_ant:=desc;
			desc:=j2[k];
			apgcrt(6*k-3,2);
			dsncrt(desc,36,10,true);
			
			for i:=k+1 to 10 do
			begin
				j2[i-1]:=j2[i];
				gotoxy(63,25);
				delay(40);
				apgcrt(6*i-3,2);
				dsncrt(j2[i-1],6*(i-1)-3,2,mostrar);
			end;
			
			gotoxy(52,8);
			textbackground(2);
			textcolor(0);
			if mostrar then
				write('Trincas: ',ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9]))
			else
				write('          ');
			if ntrinca(j2[1],j2[2],j2[3],j2[4],j2[5],j2[6],j2[7],j2[8],j2[9])=3 then
			begin
				msg('CPU vence!');
				orgcrt;
				for i:=1 to 9 do
					dsncrt(j2[i],6*i-3,2,true);
				v2:=v2+1;
				textbackground(2);
				textcolor(0);
				gotoxy(5,8);
				write(v2);
				break;
			end;
			
			msg('Pegue uma carta no baralho ou no descarte');
			
			k:=1;
			textcolor(14);
			gotoxy(12*k+11,9);	write(#218,'     ',#191);
			gotoxy(12*k+11,15);	write(#192,'     ',#217);
			
			repeat
				
				gotoxy(63,25);
				tcl:=lertcl;
				
				gotoxy(12*k+11,9);	write('       ');
				gotoxy(12*k+11,15);	write('       ');
				
				if (tcl=#75) and (k=2) then
					k:=1;
				if (tcl=#77) and (k=1) then
					k:=2;
				
				if tcl=#13 then
					break;
				
				gotoxy(12*k+11,9);	write(#218,'     ',#191);
				gotoxy(12*k+11,15);	write(#192,'     ',#217);
				
			until false;
			
			if k=1 then	// pegar carta no baralho
			begin
				j1[10]:=baralho[ncrt];
				ncrt:=ncrt-1;
				dsncrt(baralho[ncrt],24,10,false);
			end
			else	// pegar carta no descarte
			begin
				j1[10]:=desc;
				desc:=desc_ant;
				if desc=0 then
					apgcrt(36,10)
				else
					dsncrt(desc,36,10,true);
			end;
			
			dsncrt(j1[10],57,18,true);
			
			i:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9]);
			
			j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[6],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[5],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[3],j1[4],j1[6],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[3],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[2],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[1],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			j:=ntrinca(j1[2],j1[3],j1[4],j1[5],j1[6],j1[7],j1[8],j1[9],j1[10]);
			if j>i then i:=j;
			
			textbackground(2);
			textcolor(0);
			gotoxy(52,24);
			write('Trincas: ',i);
		
		until false;
		
		textbackground(2);
		textcolor(14);
		gotoxy(12,16);
		write('Pressione ENTER para jogar outra partida');
		gotoxy(63,25);
		repeat
		until readkey=#13;
		
	   until false;
		
	End.
