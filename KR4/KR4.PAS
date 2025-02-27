Program FreqDict;
CONST  WordLen = 31;
TYPE  TextWord = string[WordLen];
    Node= RECORD
            key: TextWord;
            count:longint;
            left, right: LongInt
         END;
    TreeFile=file of Node;
(*+++++++��������� � �������+++++++*)
    
	(*
	�㭪�� GetReqResult �������� ������� �⢥� "��" ��� "���" �� ���짮��⥫�.
	�����頥� true � ��砥 ᮣ���� ���짮��⥫�, false - � ��砥 ��ᮣ����.
	��ࠬ����:
	����������.
	������� ��६����:
	answer - ⥪�騩 �⢥� ���짮��⥫�.
	*)
	function GetReqReslt:boolean;
	var answer:char;
	begin
		ReadLn(answer);
		while (UpCase(answer)<>'Y')
			   and(UpCase(answer)<>'N') do begin
			WriteLn('���ࠢ���� �⢥�! �����⨬�:',#13#10,'Y - ��; N - ���.');
			ReadLn(answer);
		end;
		GetReqReslt:=UpCase(answer)='Y';
	end;
	(*
	�㭪�� IsLetter �஢����, ���� �� ᨬ��� ch �㪢��.
	�᫨ ��, �����頥� true, ���� - false.
	��ࠬ����:
	ch - ᨬ��� ��� �஢�ન.
	������� ��६����:
	����������.
	*)
	function IsLetter(ch:char):boolean;
    begin
         if ('A'<=ch) and (ch<='Z') or
            ('a'<=ch) and (ch<='z') or
            ('�'<=ch) and (ch<='�') or
            ('�'<=ch) and (ch<='�')
               then IsLetter:=true
               else IsLetter:=false;
    end;
	
	(*
	�㭪�� IsInWordSymbol �஢����, ���� �� ᨬ��� ch �����⨬� ��� �ᯮ�짮����� ����� ᫮��.
	�᫨ ��, �����頥� true, ���� - false.
	��ࠬ����:
	ch - ᨬ��� ��� �஢�ન.
	������� ��६����:
	����������.
	*)
    function IsInWordSymbol(ch:char):boolean;
    begin
         if ('0'<=ch) and (ch<='9')
            or (ch='''')  or (ch='-') or (ch='_')
                then IsInWordSymbol:=true
                else IsInWordSymbol:=false;
    end;

	(*
	�㭪�� cap �����頥� ��������� �㪢�,ᮮ⢥�����饩 ���筮� �㪢� ch.
	�᫨ ch 㦥 ��������� �㪢� ��� ����� �� �㪢�, � �����頥��� ���祭��  ch.
	��ࠬ����:
	ch - ᨬ��� ��� �������樨.
	������� ��६����:
	����������.
	*)
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
	
	(*
	�㭪�� Compare �ࠢ������ 2 ��ப� a � b ������ ����᪨.
	�᫨ a<b, �����頥��� -1; �᫨ ࠢ�� - �����頥��� 0;
		�᫨ ����� - 1.
	��ࠬ����:
	a,b - ��ப� ��� �ࠢ�����.
	������� ��६����:
	lena,lenb,len - ����� ��ப� a/��ப� b/��������� �� ���;
    i - ��६����� ���稪;
	*)
    function Compare(const a,b:string):shortint;
    var lena,lenb,len:byte;
       i:byte;
    begin
         lena:=length(a); lenb:=length(b);
         if lena > lenb then len:=lenb else len:=lena;
         i:=1;
         while (i<=len) and (a[i]=b[i]) do begin
               inc(i);
         end;

         if i>len then begin
            if lena=lenb then
               Compare:=0
            else if lena<lenb then
                    Compare:=-1
                  else Compare:=1;
         end else begin
             if a[i] <>'�' then
                if a[i]<b[i] then
                    Compare:=-1
                  else Compare:=1
             else
                 if b[i]<='�' then
                    Compare:=1
                 else
                     Compare:=-1;
         end;

    end;
    
	(*
	��楤�� PrintTree ���⠥� ��ॢ� ᫮���� � 䠩�� Tree � ⥪�⮢� 䠩� outFile.
	������� "����⪮�" � �㭪樨 ४��ᨢ��� ���� RecPrint.
	��ࠬ����:
	outFile - ⥪�⮢� 䠩� ��� �뢮��.
	Tree - ⨯���஢���� 䠩� Tree � ��ॢ�� ᫮����.
    ������� ��६����:
	����������.
	*)
	PROCEDURE PrintTree(var Tree:TreeFile; var outFile:Text);
        
		(*
		��楤�� RecPrint � ������� ४��ᨨ ���⠥� ��ॢ� ᫮����
		� 䠩�� Tree (��।������ ������쭮) � ⥪�⮢� 䠩� outFile (��।������ ������쭮).
		�㭪�� ���⠥� ������� � ����஬ Number: 
		᭠砫� ��� ����� �����ॢ�, ��⥬ ᠬ �������, ��⥬ ��� �ࠢ�� �����ॢ�/
		��ࠬ����:
		Number - ����� ⥪�饣� ������� ��� ����.
		������� ��६����:
		Current - ⥪�騩 ������� ��� ����.
		*)
        procedure RecPrint(Number: Longint);
        var Current:Node;
        BEGIN
            seek(Tree,Number); Read(Tree,Current);

            IF  Current.left>0 Then begin
                RecPrint(Current.left);
            end;
            WriteLn( outFile, Current.key,' ',Current.count);
            IF  Current.right>0 Then begin
                RecPrint(Current.right);
        end;
        END {RecPrint};
        
    begin
         recprint(0);
    end {PrintTree};
	
	(*
	��楤�� GetWord ����砥� �� 䠩�� inFile ᫥���饥 ᫮��, �᫨ ��� ����.
	���� �����頥��� ����� ��ப�.
	��ࠬ����:
	inFile - 䠩� � ��室�� ⥪�⮬.
	������� ��६����:
	temp - ⥪�饥 �����祭��� ᫮��;
	i - ����� �����祭���� ᫮��;
	ch - ⥪�騩 �����祭�� ᨬ���;
	founded - �����뢠��, �뫮 �� ������� ᫮��.
	*)
    function GetWord(var inFile:text):TextWord;
    var temp:TextWord;founded:boolean;ch:char;i:integer;
    begin
        temp:='';
        founded:=false;i:=0;
        while not (eof(inFile) or founded) do begin
            Read(inFile,ch);
            IF IsLetter(ch) THEN BEGIN
                founded:=true;inc(i); temp[i] := cap(ch);Read(inFile,ch);

                while not eof(inFile) and (i <= WordLen)
                      and (IsLetter(ch) or IsInWordSymbol(ch)) do begin
                    inc(i); temp[i] := cap(ch);
                    Read(inFile,ch);

                end;
                if  IsLetter(ch) or IsInWordSymbol(ch) then begin
                    inc(i); temp[i] := cap(ch);
                end;
                temp[0] := chr(i); (* ����� 楯�窨 ���� *)
            END;

        end;
        if founded then
            GetWord:=temp
        else
            GetWord:='';

    end;
	
	(*
	��楤�� MergeTree ᮧ���� � ⨯���஢����� 䠩�� Tree ��ॢ� ᫮����,
	��室����� � 䠩��-���筨�� inFile.
	��ࠬ����:
	inFile - 䠩� � ��室�� ⥪�⮬.
	Tree - ⨯���஢���� 䠩� Tree � ��ॢ�� ᫮����.
	������� ��६����:
	key - ⥪�饥 �����祭��� ᫮��; 
	fileinit - �����뢠��, �뫮 �� ���樠����஢��� ��ॢ� � 䠩�� Tree(true - ��);
	FreeIndex - ����� ������⮣� ������� � 䠩�� Tree;
	*)
    PROCEDURE MergeTree( VAR inFile: text; var Tree:TreeFile );
		
		(*
		��楤�� AddKey �������� � ��ॢ� Tree ���� key,
		�� �⮬ ���뢠���� ��������� ����室������ ���樠����樨 䠩��(fileinit),
		� ����� ᢮������� ��� ����� ����� � 䠩��(FreeIndex).
		��ࠬ����:
		key - ����, ��⠢�塞� � ��ॢ�,
		fileinit - �����뢠��, �뫮 �� ���樠����஢��� ��ॢ� � 䠩�� Tree(true - ��);
		FreeIndex - ����� ������⮣� ������� � 䠩�� Tree;
		Tree - ⨯���஢���� 䠩� Tree � ��ॢ�� ᫮����.
		������� ��६����:
		TempNode - ᮧ������� � ��⠢�塞� � ��ॢ� 㧥�;
        Rider,PrevRider - ⥪�騩 � �।��騩 ����� ��ᬠ�ਢ����� 㧫�� ��ॢ�; 
		founded - �����뢠��, �� �� ������ � ��ॢ� ��⠢�塞� ����(�.�. ������� �� �� 㦥);
		status - �����뢠�� ��襭�� �ࠢ�������� ���祩
					(1 - ��⠢�塞� �����;
					 0 - ࠢ��;
					 -1 - ��⠢�塞� �����;)
		*)
        PROCEDURE AddKey(var Tree:TreeFile; const key: TextWord;var FreeIndex:longint;var fileinit:boolean);
        var TempNode:Node;
            Rider,PrevRider:longint; founded:boolean;status:shortint;
        BEGIN
            {**Root node position**}
            if FileInit then begin {**File initialized**}
                {**Read root node**}
                Rider:=0;
                repeat
                    PrevRider:=Rider;
                    seek(Tree,Rider);Read(Tree,TempNode);
                    status:=Compare(key,TempNode.key);
                    Case status of
                        1:Rider:=TempNode.right;
                        -1:Rider:=TempNode.left;
                        0:begin
                            Rider:=0;
                        end;
                    end;
                until Rider<=0;
                if Rider=0 then begin
                    inc(TempNode.Count);
                    seek(Tree,PrevRider);write(Tree,TempNode);
                end else begin
                    {**Prepare and write parent node**}
                    
                    Case Rider of
                        -1:TempNode.right:=FreeIndex;
                        -2:TempNode.left:=FreeIndex;
                    End;
                    seek(Tree,PrevRider);write(Tree,TempNode);
                    {**Prepare and write new child node**}
                    TempNode.key:=key; TempNode.count:=1;
                    TempNode.right:=-1; TempNode.left:=-2;
                    seek(Tree,FreeIndex);write(Tree,TempNode);
                    inc(FreeIndex);
                end;
            end else begin
                {**Prepare and write root node**}
                
                TempNode.key:=key; TempNode.count:=1;
                TempNode.right:=-1; TempNode.left:=-2;
                seek(Tree,0);write(Tree,TempNode);
                FreeIndex:=1; fileinit:=true;
            end;
        END {AddKey};

    VAR
        key: TextWord; fileinit:boolean;FreeIndex:longint;
    BEGIN
        FreeIndex:=0;Fileinit:=false;
        key:=GetWord(inFile);
        WHILE (key<>'') DO begin
            AddKey(Tree,key,FreeIndex,fileinit);
            key:=GetWord(inFile);
        END;
    END {MergeTree};


    function TreeFileExists(var f:TreeFile):boolean;
    begin
         {$I-}
              Reset(f);
         {$I+}
         if ioresult=0 then begin

            TreeFileExists:=true;
            Close(f);
         end else TreeFileExists:=false
    end {FileExist};
	
	function FileExists(var f:text):boolean;
	var exist:boolean;
	begin
		{$I-}
			ReSet(f);
		{$I+}
		exist:=ioresult=0;
		if exist then close(f);
		FileExists:=exist;
	end;
	(*
	�㭪�� GetFiles ����砥� 䠩� � ��室�� ⥪�⮬ inFile,
	�६���� 䠩� ��� ��ॢ� Tree,
	� 䠩� ��� �뢮�� outFile.
	�����頥� true, �᫨ ������ ��諠 �ᯥ譮, ���� �����頥��� false.
	��ࠬ����:
	inFile - 䠩� � ��室�� ⥪�⮬.
	outFile - ⥪�⮢� 䠩� ��� �뢮��.
	Tree - ⨯���஢���� 䠩� � ��ॢ�� ᫮����.
	������� ��६����:
	ok - 䫠� ������⢨� �訡�� (true - ��� �訡��).
	*)
    function GetFiles(var inFile:text; var Tree:TreeFile; var outFile:text):boolean;
		(*
		�㭪�� GetInFile() ����砥� 䠩� f ��� �⥭��.
		�����頥� true, �᫨ ������ ��諠 �ᯥ譮, ���� �����頥��� false.
		��ࠬ����:
		f - ����訢���� 䠩�.
		������� ��६����:
		error - 䫠� �訡�� (true - �訡��);
		req_rslt - 䫠� �⢥� ���짮��⥫� (true - ᮣ��ᨥ ���짮��⥫�).
		*)
		function GetInFile(var f:text):boolean;
		var error,req_rslt:boolean;
			fileName:string;
		begin
			error:=false; req_rslt:=false;
			repeat
				WriteLn('������ ��� 䠩�� � ⥪�⮬ ��� �������.');
				Write('����:');ReadLn(fileName);
				Assign(f,fileName);
				{$I-}
					Reset(f);
				{$I+}
				error:=(ioresult<>0)or(fileName='');
				if error then begin
					WriteLn('���ࠢ��쭮� ��� 䠩��! ������� ����? <Y>/<N>');
					req_rslt:=GetReqReslt;
				end;
			until not error or not req_rslt;
			GetInFile:=not error;
		end;
		
		(*
		�㭪�� GetTmpFile() ����砥� �६���� ⨯���஢���� 䠩� f.
		�����頥� true, �᫨ ������ ��諠 �ᯥ譮, ���� �����頥��� false.
		��ࠬ����:
		f - ����訢���� 䠩�.
		������� ��६����:
		error - 䫠� �訡�� (true - �訡��);
		req_rslt - 䫠� �⢥� ���짮��⥫� (true - ᮣ��ᨥ ���짮��⥫�).
		*)
        function GetTmpFile(var f:TreeFile):boolean;
        const DefaultName='$temp.tmp';
        var ch:char; error,req_rslt:boolean;
            fileName:string;
        begin
            FileName:=DefaultName;
            repeat
                assign(f,fileName);
                If TreeFileExists(f) then begin
                   WriteLn('������ ��� �६������ 䠩��');
                   Write('����:');ReadLn(fileName);
                end else begin
                   {$I-}
                        ReWrite(f);
                   {$I+}
                   error:=(ioresult<>0)or(fileName='');
                   if error then begin
                       WriteLn('�訡�� �� ᮧ����� 䠩��! ������� ����? <Y>/<N>');
                       req_rslt:=GetReqReslt;
                   end;
                end;
            until not req_rslt or not error;
            GetTmpFile:= not error;
        end {GetTmpFile};
		
		(*
		�㭪�� GetOutFile() ����砥� 䠩� f ��� �����.
		�����頥� true, �᫨ ������ ��諠 �ᯥ譮, ���� �����頥��� false.
		��ࠬ����:
		f - ����訢���� 䠩�.
		������� ��६����:
		error - 䫠� �訡�� (true - �訡��);
		req_rslt - 䫠� �⢥� ���짮��⥫� (true - ᮣ��ᨥ ���짮��⥫�).
		*)
		function GetOutFile(var f:text):boolean;
		var error,req_rslt:boolean;
			fileName:string;
		begin
			error:=false; req_rslt:=false;
			repeat
				WriteLn('������ ��� 䠩�� ��� ���⭮�� ᫮����.');
				Write('����:');ReadLn(fileName);
				Assign(f,fileName);
				if FileExists(f) then begin
					error:=true;
					WriteLn('�������� 䠩� �������! ��१������? (Y/N)');
					error:=not GetReqReslt;
				end;
				if not error then begin
					{$I-}
					ReWrite(f);
					{$I+}
					error:=(ioresult<>0)or(fileName='');
				end;
				if error then begin
					WriteLn('�訡�� �� ᮧ����� 䠩��! ������� ����? <Y>/<N>');
					req_rslt:=GetReqReslt;
				end;
			until not error or not req_rslt;
			GetOutFile:=not error;
		end;

    var ok:boolean;
    begin
        ok:=GetInFile(inFile);
        if ok then
            ok:=GetTmpFile(Tree);
        if ok then
            ok:=GetOutFile(outFile);
        GetFiles:=ok;
    end;
(*-------��������� � �������-------*)
(*
�᭮���� ���� �ணࠬ�� ����祭�� ���⭮�� ᫮����.
��६����:
inFile - 䠩� � ��室�� ⥪�⮬.
outFile - ⥪�⮢� 䠩� ��� �뢮��.
Tree - ⨯���஢���� 䠩� � ��ॢ�� ᫮����.
ok - 䫠� ������⢨� �訡�� (true - ��� �訡��);
*)
VAR  inFile, outFile: Text;
     Tree: TreeFile; ok:boolean;
BEGIN
    WriteLn('�ணࠬ�� ��⠢��� ��䠢��� ����� ᫮����');
    WriteLn('�� 䠩��, ����ᠭ���� � ⥪�⮢�� 䠩��,');
    WriteLn('� �뢮��� ᫮���� � ��室��� ⥪�⮢� 䠩�');
    ok:=GetFiles(inFile, Tree, outFile);
    if ok then begin
       writeln('��ࠡ�⪠ �室���� ⥪��... ');
       writeln('��������, ��������...');
       MergeTree(InFile,Tree);
       WriteLn;
       writeLn('������ १���⮢...');
       writeln('��������, ��������...');
       PrintTree(Tree,outFile);
       Close(inFile); close(outFile);
       close(Tree); Erase(Tree);
       WriteLn;
       WriteLn('�� ����樨 �����襭� �ᯥ譮!')
    end else
       WriteLn('����� �ணࠬ�� ��ࢠ��...');
    WriteLn('������ <Enter>...');Readln;
END.
