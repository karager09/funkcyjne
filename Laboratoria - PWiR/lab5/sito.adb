
with Ada.Text_IO, Ada.Integer_Text_IO, Unchecked_Deallocation;
use Ada.Text_IO, Ada.Integer_Text_IO;

procedure Sito is

type Element is record 
	Data : Integer := 0;
	Next : access Element := Null;
end record;

type Elem_Ptr is access all Element;

procedure Free is new Unchecked_Deallocation(Element, Elem_Ptr);


function DodajElement(Y : in Integer) return Elem_Ptr is
(new Element'(Y, null));


function TworzListe(X : in Integer) return Elem_Ptr is
Parent : Elem_Ptr := DodajElement(2);
First : Elem_Ptr;
begin
	First := Parent;
	for I in 3..X loop
		Parent.Next := DodajElement(I);
		Parent := Parent.Next;	
	end loop;
	return First;
end TworzListe;



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


procedure UsunNiepierwsze(First : in Elem_Ptr) is
Outer : Elem_Ptr := First;
BeforInner : Elem_Ptr;
Inner : Elem_Ptr;
begin
	while Outer /= null loop
		BeforInner := Outer;
		Inner := Outer.Next;
		while Inner /= null loop
			if Inner.Data rem Outer.Data = 0 then
				BeforInner.Next := Inner.Next;
				Free(Inner);
				Inner := BeforInner.Next;
			else
				BeforInner := Inner;
				Inner := Inner.Next;

			end if;
		end loop;

	Outer := Outer.Next;
	end loop;
end UsunNiepierwsze;




Lista : Elem_Ptr;
begin

Lista := TworzListe(103);
Print(Lista);

UsunNiepierwsze(Lista);
Print(Lista);

end Sito;
