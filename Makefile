F90 = gfortran
FLAGS = -O0 -Wall -ffpe-trap=invalid,overflow -fcheck=all
EXE = executable
all: $(EXE)

# ce qui est en bleu est une cible
# le run est juste un appel

$(EXE): constantes_mod.o appendices_mod.o function_mod.o prog_principal.o
	$(F90) $(FLAGS) -o executable constantes_mod.o appendices_mod.o function_mod.o prog_principal.o
constantes_mod.o : constantes_mod.f90
	$(F90) $(FLAGS) -c constantes_mod.f90
appendices_mod.o : constantes_mod.o appendices_mod.f90
	$(F90) $(FLAGS) -c appendices_mod.f90
function_mod.o : constantes_mod.o appendices_mod.o function_mod.f90
	$(F90) $(FLAGS) -c function_mod.f90
prog_principal.o : constantes_mod.o appendices_mod.o function_mod.o prog_principal.f90
	$(F90) $(FLAGS) -c prog_principal.f90

clean :
	rm *.o *.mod
