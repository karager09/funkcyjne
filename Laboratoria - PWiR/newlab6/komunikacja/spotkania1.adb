-- spotkania1.adb

with Ada.Text_IO;
use Ada.Text_IO;

procedure Spotkania1 is
	
task Zadanie_A is
  entry Start;	
end Zadanie_A;

task Zadanie_B is 
  entry Start;
end Zadanie_B;

task body Zadanie_A is
begin
  accept Start;	
  Put_Line("P_A ");
  Put_Line("Z_A "); 
  Put_Line("K_A ");
end Zadanie_A;

task body Zadanie_B is
begin
  accept Start;
  Put_Line("P_B ");
  Put_Line("Z_B ");  			
  Put_Line("K_B ");
end Zadanie_B;

begin
  Put_Line("Poczatek_PG ");
  Put_Line("Start Z_A");
  Zadanie_A.Start;
  delay 1.0;
  Put_Line("Start Z_B "); 
  Zadanie_B.Start; 
  Put_Line("Koniec_PG ");
  
end Spotkania1;
	  	