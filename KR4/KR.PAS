{$M 65520,0,650000}
var count:longint;
CONST  WordLen = 31;
CONST  Alphabet = ['a'..'z','A'..'Z','�'..'�','�'..'�'];
       Capitals = ['A'..'Z','�'..'�'];
TYPE  Word = string[WordLen];
    {Node = ^TNode;}
    Node = ^TList;
    TList = record
          key:Word;
          count:integer;
          next:Node;
    end;
    TNode= RECORD
            key: Word;
            count:INTEGER;  (*ᯨ᮪*)
            left, right: Node  (*��ॢ�*)
    END;

VAR  line: INTEGER;  WF: Text;
    function cap(const ch:char):char;
    begin
         case ch of
         'a'..'z':cap:=UpCase(ch);
         '�'..'�':cap:=chr(ord(ch)-32);
         '�'..'�':cap:=chr(ord(ch)-80);
         '�':cap:='�';
         else cap:=ch;
         end;
    end;

    function Compare(const a,b:string):shortint;
    var lena,lenb,len:byte;
       i:byte;equal:boolean;
    begin
         lena:=length(a); lenb:=length(b);
         if lena > lenb then len:=lenb else len:=lena;
         i:=1;
         equal:=true;Compare:=0;
         while (i<=len) and (a[i]=b[i]) do begin
               inc(i);
         end;

         if i>len then begin
            if lena=lenb then
               Compare:=-1
            else Compare:=ord(lena<lenb);
         end else begin
             if cap(a[i]) <>'�' then
                Compare:=ord(a[i]<b[i])
             else
                 if b[i]<='�' then
                    Compare:=0
                 else
                     Compare:=1
         end;

    end;
    Procedure searchlist(var w:node;var a:Word);
    var w1:Node;
    begin
       w1:=w^.next;
       if w1<>NIL then begin
         if (Compare(w1^.key,a)<>-1) then begin
            while (w1^.next <> NIL) and (Compare(w1^.next^.key,a)<>-1) do
               w1:=w1^.next;
            if w1^.next=NIL then begin
               NEW(w1^.next);w1^.next^.key:=a;w1^.next^.count:=1;w1^.next^.next:=nil;
            end else inc(w1^.next^.count);
         end else inc(w1^.count);
       end else begin
         NEW(w^.next);w^.next^.key:=a;w^.next^.count:=1;w^.next^.next:=nil;
       end;
    end;
    {PROCEDURE search ( VAR w: Node;  VAR a: Word );
    BEGIN
        IF  w = NIL  THEN BEGIN (* ᫮�� � ��ॢ� ���; ��⠢��� ���� 㧥� *)
            NEW( w );inc(count);
            w^.key := a;  w^.count:=1;  w^.left := NIL;  w^.right := NIL
        end
        ELSE Case Compare(w^.key,a)  of
             1:  search( w^.right, a);
             0: search( w^.left, a );
             -1: inc(w^.count);
        END;

    END search;
    }
    PROCEDURE Tabulate ( w: Node );
    BEGIN
        while w<>NIL do begin
           Writeln(wf,w^.key,' ',w^.count);
           w:=w^.next;
        end;
        {IF  w <> NIL  THEN BEGIN
            Tabulate( w^.left );
            Write( WF, w^.key,' ',w^.count);
            WriteLn(WF);
            Tabulate( w^.right )
        END}
    END {Tabulate};

    PROCEDURE CrossRef ( VAR R: text );
        VAR  root: Node;  (* �ᯮ������ �������� ��ꥪ� ���� WF *)
            i: INTEGER;  ch: CHAR;  w: Word;
    BEGIN
        {write( WF, 0); Write(WF,'':6);}

        New(root);  line := 0;
        Read( R, ch );
        WHILE  not eof(R)  DO begin
            IF  ch = #13  THEN BEGIN (*����� ��ப�*)
                {WriteLn( WF );}
                INC( line );
                {Write (WF, line);  Write(WF,'':6-trunc(ln(line)/ln(10)));}
                Read( R, ch )
            end ELSE IF ch in Alphabet THEN BEGIN
                i := 1;
                REPEAT
                    IF  i < WordLen  THEN BEGIN  w[ i ] := cap(ch);  INC( i )  END;
                    {Write( WF, ch );}
                    Read( R, ch )
                UNTIL (i = WordLen) OR not(ch in Alphabet);

                w[0] := chr(i-1); (* ����� 楯�窨 ���� *)
                searchlist( root, w )
            END ELSE BEGIN
                {Write( WF, ch );}
                Read( R, ch )
            END;
        END;
        {WriteLn( WF );  WriteLn( WF );}
        Tabulate( root^.next )
    END {CrossRef};
    (* ����� �ࠣ����. ****************************************************************)


VAR  R: text;
BEGIN
    Assign (R,'voina.txt'); Assign(WF,'test.txt');count:=0;
    Reset(R); Rewrite(WF);
    CrossRef(R);WriteLn('OK!');Readln
END.