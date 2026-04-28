datassembler.exe /a Submod_text.txt
datassembler.exe /a Coresaga_text.txt
del buildlogCoresaga.txt
ren buildlog.txt buildlogCoresaga.txt
datassembler.exe /a TR_text.txt
del buildlogTR.txt
ren buildlog.txt buildlogTR.txt
datassembler.exe /a FotR_text.txt
del buildlogFotR.txt
ren buildlog.txt buildlogFotR.txt
datassembler.exe /a RevRev_text.txt
del buildlogRev.txt
ren buildlog.txt buildlogRev.txt
datassembler.exe /a

datassembler.exe /b MasterTextFile_ENGLISH.txt ../../../TR/Data/Text/German/MasterTextFile_ENGLISH.dat -r:Coresaga_text.txt -r:TR_text.txt
datassembler.exe /b MasterTextFile_ENGLISH.txt ../../../FotR/Data/Text/German/MasterTextFile_ENGLISH.dat -r:Coresaga_text.txt -r:FotR_text.txt
datassembler.exe /b MasterTextFile_ENGLISH.txt ../../../Rev/Data/Text/German/MasterTextFile_ENGLISH.dat -r:RevRev_text.txt

@echo off
echo.
echo.
echo.
>nul findstr /c:"TEXT_" buildlog.txt && (
  echo MasterTextFile_ENGLISH.txt has duplicate entry
) || (
  echo MasterTextFile_ENGLISH.txt clear
)

>nul findstr /c:"TEXT_" buildlogCoresaga.txt && (
  echo Coresaga_text.txt has duplicate entry
) || (
  echo Coresaga_text.txt clear
)

>nul findstr /c:"TEXT_" buildlogTR.txt && (
  echo TR_text.txt has duplicate entry
) || (
  echo TR_text.txt clear
)

>nul findstr /c:"TEXT_" buildlogFotR.txt && (
  echo FotR_text.txt has duplicate entry
) || (
  echo FotR_text.txt clear
)

>nul findstr /c:"TEXT_" buildlogRev.txt && (
  echo RevRev_text.txt has duplicate entry
) || (
  echo RevRev_text.txt clear
)
pause