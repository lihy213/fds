@echo off

IF "%SETUP_IFORT_COMPILER_64%"=="1" GOTO envexist
IF  X"%SETVARS_COMPLETED%" == X1 GOTO oneapi_envexist

  set SETUP_IFORT_COMPILER_64=1

  IF DEFINED IFORT_COMPILER14 set IFORT_COMPILER=%IFORT_COMPILER14%
  IF DEFINED IFORT_COMPILER15 set IFORT_COMPILER=%IFORT_COMPILER15%
  IF DEFINED IFORT_COMPILER16 set IFORT_COMPILER=%IFORT_COMPILER16%
  IF DEFINED IFORT_COMPILER17 set IFORT_COMPILER=%IFORT_COMPILER17%
  IF DEFINED IFORT_COMPILER18 set IFORT_COMPILER=%IFORT_COMPILER18%
  IF DEFINED IFORT_COMPILER19 set IFORT_COMPILER=%IFORT_COMPILER19%
  IF DEFINED IFORT_COMPILER20 set IFORT_COMPILER=%IFORT_COMPILER20%
  IF DEFINED IFORT_COMPILER21 set IFORT_COMPILER=%IFORT_COMPILER21%

:: setup environment for oneapi compilers
  IF NOT DEFINED I_MPI_ONEAPI_ROOT  GOTO SKIP_ONEAPI
    IF DEFINED %IFORT_COMPILER19%       set IFORT_COMPILER=%IFORT_COMPILER19%
    IF DEFINED %IFORT_COMPILER21%       set IFORT_COMPILER=%IFORT_COMPILER21%
    IF DEFINED I_MPI_ONEAPI_ROOT       set I_MPI_ROOT=%I_MPI_ONEAPI_ROOT%
:SKIP_ONEAPI

  IF NOT DEFINED IFORT_COMPILER (
    echo "*** Error: Intel compiler environment not defined."
    exit /b
  )
  IF NOT DEFINED I_MPI_ROOT (
    echo "*** Error: Intel MPI environment not defined."
    exit /b
  )

  echo Setting up compiler environment
  set STARTUP="%IFORT_COMPILER%\bin\compilervars"
  IF DEFINED ONEAPI_ROOT set STARTUP="%ONEAPI_ROOT%\setvars"
  
:: the compilervars script overwrites the mpi library locattion so we have to save it
:: (the mpi install puts the mpi library in a different place than the Fortran install)
  set "IMPI_ROOT_SAVE=%I_MPI_ROOT%"
  call %STARTUP% intel64

  if NOT DEFINED I_MPI_ONEAPI_ROOT echo Setting up MPI environment
  set "I_MPI_ROOT=%IMPI_ROOT_SAVE%"
  set IMPI_RELEASE_ROOT=%I_MPI_ROOT%\intel64\lib
  set   IMPI_DEBUG_ROOT=%I_MPI_ROOT%\intel64\lib
  IF DEFINED IFORT_COMPILER19 set IMPI_RELEASE_ROOT=%I_MPI_ROOT%\intel64\lib\release
  IF DEFINED IFORT_COMPILER19 set IMPI_DEBUG_ROOT=%I_MPI_ROOT%\intel64\lib\debug
  IF DEFINED IFORT_COMPILER20 set IMPI_RELEASE_ROOT=%I_MPI_ROOT%\intel64\lib\release
  IF DEFINED IFORT_COMPILER20 set IMPI_DEBUG_ROOT=%I_MPI_ROOT%\intel64\lib\debug
  IF DEFINED IFORT_COMPILER21 set IMPI_RELEASE_ROOT=%I_MPI_ROOT%\intel64\lib\release
  IF DEFINED IFORT_COMPILER21 set IMPI_DEBUG_ROOT=%I_MPI_ROOT%\intel64\lib\debug

:: define oneapi mpi environment
  IF DEFINED I_MPI_ONEAPI_ROOT set IMPI_RELEASE_ROOT=%I_MPI_ONEAPI_ROOT%\lib\release
  IF DEFINED I_MPI_ONEAPI_ROOT set IMPI_DEBUG_ROOT=%I_MPI_ONEAPI_ROOT%\lib\debug

  set IMPI_INCLUDE=%IMPI_RELEASE_ROOT%\intel64\include
  IF DEFINED I_MPI_ONEAPI_ROOT set IMPI_INCLUDE=%IMPI_RELEASE_ROOT%\include

  if NOT DEFINED I_MPI_ONEAPI_ROOT call "%I_MPI_ROOT%\intel64\bin\mpivars" release
  :: A separate startup script for mpi is not needed for the oneAPI compilers.
  :: The oneAPI setup script defines the environment for mkl and mpi libraries
  ::    todo: add parameters to the oneAPI startup script to not define the environment
  ::    for everyting else

:oneapi_envexist
:envexist
