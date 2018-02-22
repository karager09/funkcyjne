with Ada.Text_IO;
use Ada.Text_IO;

procedure dwa is

type TBuf is array(Integer range <>) of Character;


generic 
	Rozmiar: Natural;
	type Typ_Elementu is (<>);
package Buf_Gen is
	type TBuf1 is array(Integer range 1..Rozmiar) of Typ_Elementu;
	B : TBuf1;
	LiczElem  : Integer:=0;
	PozPob   : Integer:=1;
	PozWstaw : Integer:=1;
	procedure Wstaw(Element : in Typ_Elementu);
	procedure Pobierz(Element: out Typ_Elementu);
end Buf_Gen;

package body Buf_Gen is
procedure Wstaw(Element : in Typ_Elementu) is begin
if LiczElem < Rozmiar then
	B(PozWstaw) := Element;
	LiczElem := LiczElem + 1;
	if PozWstaw = B'Last then
		PozWstaw := 1;
	else PozWstaw := PozWstaw + 1;
end if;
end if;
end Wstaw;


procedure Pobierz(Element: out Typ_Elementu) is begin
if LiczElem>0 then
	Element := B(PozPob);
	LiczElem := LiczElem - 1;
	if PozPob = B'Last then 
		PozPob := 1; 
	else PozPob := PozPob + 1; 
	end if;
end if;
end Pobierz;

end Buf_Gen;



package Cos is new Buf_Gen(5,Character);
Ch: Character;
begin
	Cos.Wstaw('s');
	Cos.Pobierz(Ch);
	Put_Line(Ch'Img);
end dwa;
