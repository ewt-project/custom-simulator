program VectPotential;

uses
  Forms,
  VectorPotential in 'VectorPotential.pas' {Form1};

// Set IMAGE_FILE_LARGE_ADDRESS_AWARE $0020 (up to 4Gb, rather than 2Gb, on a 64 bit PC)
// And IMAGE_FILE_NET_RUN_FROM_SWAP $0800
// And IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP $0400
// And IMAGE_FILE_RELOCS_STRIPPED $0001
{$SetPEFlags $0C21}

{$E .exe}

{$R *.RES}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'VectorPotential';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
