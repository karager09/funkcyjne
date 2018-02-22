with Ada.Text_IO;
use Ada.Text_IO;

procedure Buf is

type TBuf is array(Integer range <>) of Character;

protected type Buf(Rozmiar : Integer) is -- bufor ograniczony
entry Wstaw(Ch : in Character);
entry Pobierz(Ch : out Character); 
private
 B : TBuf(1..Rozmiar);
 LiczElem  : Integer:=0;
 PozPob   : Integer:=1;
 PozWstaw : Integer:=1;
end Buf;

protected body Buf is
entry Wstaw(Ch : in Character)
when LiczElem < Rozmiar is begin
	B(PozWstaw) := Ch;
	LiczElem := LiczElem + 1;
	if PozWstaw = B'Last then
		PozWstaw := 1;
	else PozWstaw := PozWstaw + 1;
end if;
end Wstaw;

entry Pobierz(Ch: out Character)
when LiczElem>0 is begin
	Ch := B(PozPob);
	LiczElem := LiczElem - 1;
	if PozPob = B'Last then 
		PozPob := 1; 
	else PozPob := PozPob + 1; 
	end if;

end Pobierz;
end Buf;


Bufor : Buf(10);


-- specyfikacja zadania
-- Producent
task Producent;
Ch : Character := 'a';
task body Producent is begin
	for I in 1..9 loop
		Bufor.Wstaw(Ch); 
	end loop;
end Producent;
-- specyfikacja zadania
-- Konsument
task Konsument;
Ch1 : Character;
task body Konsument is begin
for I in 1..15 loop
	Bufor.Pobierz(Ch1);
	Put_Line(Ch'Img);
   -- konsumpcja
end loop;
end Konsument;



begin
	null;
end Buf;
