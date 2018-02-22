-- idzad.adb

with Ada.Text_IO;
use Ada.Text_IO;

procedure IdZad is

task type Zadanie is
  entry Ident(Id: Integer);	
end Zadanie	;

task body Zadanie is
 Moj_Id: Integer := 0;	
begin
  accept Ident(Id: Integer) do
    Moj_Id := Id;
  end Ident; 	
  Put_Line("Moje Id = " & Moj_Id'Img);  
end Zadanie;

subtype Zakres is Integer range 1..10; 
Zadania: array(Zakres) of Zadanie;

begin
  Put_Line("P_PG ");
  for I in Zakres loop
  	Zadania(I).Ident(I);  			
  end loop;
  Put_Line("K_PG ");
end IdZad;
	  	