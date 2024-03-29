!Potencial de interacción: Doble Gaussiana

!Parámetro de entrada: distancia radial entre partículas
!Parámetro de entrada: energía potencial de entrada
!Parámetro de entrada: "parcial" del potencial
Subroutine FDG(r,Vij,U2)
  use variables3D

  implicit none

  !r: distancia entre partículas
  !Vij: energía potencial entre partículas
  !U: forma funcional del potencial
  !U2: parámetro general para el calculo de fuerza (-1/r)(dU/dr)
  real *4 r, Vij, U, U2

  !parámetro general para cálculo de la fuerza
  U2=(2.0/T)*exp(-r**2)-2.0*eta*(1.0-(xi/r))*exp(-(r-xi)**2)
  !calculando la energía potencial por partícula
  Vij=(1.0/T)*exp(-r**2)-eta*exp(-(r-xi)**2)

  return
end Subroutine FDG
