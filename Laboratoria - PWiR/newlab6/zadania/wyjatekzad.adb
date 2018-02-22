-- wyjatekzad.adb
-- obsuga wyątków w zadaniu

with Ada.Text_IO;
use Ada.Text_IO;

procedure WyjatekZad is

task Zadanie;

task body Zadanie is
  A : Positive := 1; -- liczby całkowice dodatnie
  B : Integer := 0; -- liczby całkowite
begin
  A := B;
exception
  when others => Put_Line("Błąd krytyczny w zadaniu 'Zadanie'!! ");
end Zadanie;

begin
  Null;
end WyjatekZad;      
