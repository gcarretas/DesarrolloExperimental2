gfortran constantes3D.f90 -c
gfortran variables3D.f90 -c
gfortran CIRAN3D.f90 -c
gfortran ENCONF3D.f90 -c
gfortran DG.f90 -c
gfortran ENPAR3D.f90 -c
gfortran MC.f90 -c
gfortran gr3D.f90 -c
gfortran DENSCTE3D.f90 -c
gfortran MC3D.f90 constantes3D.o variables3D.o CIRAN3D.o ENCONF3D.o DG.o ENPAR3D.o MC.f90 gr3D.o DENSCTE3D.o -o MC3D
