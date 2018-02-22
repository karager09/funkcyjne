-- lab4.adb
-- Materiały dydaktyczne
-- J.P. 2017

with Ada.Text_IO, Ada.Integer_Text_IO, Ada.Numerics.Discrete_Random;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Lab4Lista is

package Random_Num is new Ada.Numerics.Discrete_Random(Integer); 
use Random_Num;

type Element is
  record 
    Data : Integer := 0;
    Next : access Element := Null;
  end record;    
  
type Elem_Ptr is access all Element;

procedure Print(List : access Element) is
  L : access Element := List;
begin
  if List = Null then
    Put_Line("List EMPTY!");
  else
    Put_Line("List:");  
  end if;  
  while L /= Null loop
	  Put(">" & L.Data'Img & "# ");
    --Put(L.Data, 4); -- z pakietu Ada.Integer_Text_IO
    --New_Line;
    L := L.Next;
  end loop; 
end Print;  

procedure Insert(List : in out Elem_Ptr; D : in Integer) is
  E : Elem_Ptr := new Element; 
begin
  E.Data := D;
  E.Next := List;
  -- lub E.all := (D, List);
  List := E;
end Insert; 

-- wstawianie jako funkcja - wersja krótka
function Insert(List : access Element; D : in Integer) return access Element is 
  ( new Element'(D,List) );  
  
-- do napisania !!  
procedure Insert_Sort(List : in out Elem_Ptr; D : in Integer) is 
	E : Elem_Ptr := new Element; 
	Temp : Elem_Ptr;
begin
  -- napisz procedurę wstawiającą element zachowując posortowanie (rosnące) listy
  	E.Data := D;
	if List = Null then
	  	E.Next := Null;
	  	List := E;
	elsif List.Data >= D then
		E.Next := List;
	  	List := E;
	else
		Temp := List;
		while Temp.Next /= null and then Temp.Next.Data < D loop
			Temp := Temp.Next;
		end loop;
		E.Next := Temp.Next;
		Temp.Next := E;
	end if;
end Insert_Sort;  


procedure Generuj(N : in Integer; M: in Integer; List : in out Elem_Ptr) is
	G : Generator;
begin
	Reset(G);
	for I in 1 .. N loop
		Insert_Sort(List, abs(Random(G)) rem M);
	end loop;
end Generuj;



function Search(List : in out Elem_Ptr; X : Integer) return Boolean is
	Temp : Elem_Ptr;
begin
	Temp := List;
	while Temp /= Null and then Temp.Data /= X loop
		Temp := Temp.Next;
	end loop;
	if Temp = Null then 
		return False; 
	else return True; 
	end if; 
end Search;


procedure Usun(List : in out Elem_Ptr; X : Integer) is
	Temp : Elem_Ptr;
begin
	Temp := List;
	if Temp = null  then
		null;
	elsif Temp.Data = X then
		List := Temp.Next;
	else

		while Temp.Next /= Null and then Temp.Next.Data /= X loop
			Temp := Temp.Next;
		end loop;
		if Temp.Next = Null then 
			null;
		else 
			Temp.Next := Temp.Next.Next;
		end if; 
	end if;

end Usun;



Lista : Elem_Ptr := Null;

begin
  Print(Lista);
  --Lista := Insert(Lista, 21);
--  Print(Lista);
  Insert_Sort(Lista, 20);  
--  Print(Lista);
--  for I in reverse 1..12 loop
--    Insert_Sort(Lista, I);
--  end loop;
--  Insert_Sort(Lista, 15);
--  Insert_Sort(Lista, 15);
--  Insert_Sort(Lista, 27);
--  Insert_Sort(Lista, -3);

Generuj(10, 10, Lista);
  Print(Lista);
  Put_Line(Search(Lista,9)'Img);
	Usun(Lista,5);
	Print(Lista);

end Lab4Lista;
