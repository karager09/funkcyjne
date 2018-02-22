-- wyroznikzad.adb
-- wyróżnik w zadaniu

with Ada.Text_IO;
use Ada.Text_IO;

procedure WyroznikZad is

task type Zadanie(N: Integer := 1); 
-- parametr N <- wyróżnik
type Wsk_Zadanie is access Zadanie;

task body Zadanie is
begin
  Put_Line("Jestem w zadaniu " & N'Img);
end Zadanie;

Z1 : Zadanie(1);
Z2 : Zadanie(2);
Z3 : Zadanie(3);
WZX : Wsk_Zadanie;

begin
  WZX := new Zadanie(4);
  Put_Line("Jestem w procedurze glownej");
end WyroznikZad;  
