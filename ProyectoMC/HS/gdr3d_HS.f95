!Desarrollo Experimental II
!Ines Valenzuela
!Cálculo de la función de correlación

subroutine gdr3d(rho,rcut,N,M1)

use posiciones3d

! Declaracion de variables
  implicit none
  real*4 deltar,xl0,xlt,xl0t,yl0,ylt,yl0t,zl0,zlt,zl0t,r,rho,rt,gr
  real*4 rcut,rl,ru,c1,Ngi,Nsis,gr1,r1
  integer*4 i,j,k,m,maxbin,nbin,ng,maxr
  integer*4 N,NN2,NN3,M1
  integer, dimension(:), allocatable :: nhist
  real, dimension(:), allocatable, save :: integrando
  real*4 h, Inte, NRcut
  real *4 a1,a74,b, p, pcs1, pcs2, pcs, phi
  real*4 lambda,Tred,grlam,rlam,inta
  character nombre*40

  NN3=10000            !Tamaño del histograma
  allocate(nhist(NN3))

! Parámetros del potencial perturbativo
  lambda=1.25


! Ponemos al histograma en 0
  do i=1,NN3
  nhist(i)=0
  end do

  Inte=0.0

  phi=(pi*rho)/6.0
  deltar=0.01               !Tamaño de cada cinta
  maxbin=int(L/2.0/deltar)  !Número de cintas
  ng=int(1.0/deltar)+1      !Primer punto diferente de 0
  maxr=int(lambda/deltar)

  allocate(integrando(maxbin))

!Comparamos la distancia de la partícula j a la k en la configuracion
!M1 y la guardamos en el histograma dependiendo el número de cintas
do j=1,N

 do k=1,N

  if(j.ne.k) then

  do m=1,M1
  xl0=cx(j,m)
  xlt=cx(k,m)
  xl0t= xl0-xlt

  yl0=cy(j,m)
  ylt=cy(k,m)
  yl0t= yl0-ylt

  zl0=cz(j,m)
  zlt=cz(k,m)
  zl0t= zl0-zlt

  xl0t=xl0t-L*anint(xl0t/L)
  yl0t=yl0t-L*anint(yl0t/L)
  zl0t=zl0t-L*anint(zl0t/L)

  r=sqrt(xl0t*xl0t + yl0t*yl0t + zl0t*zl0t)
  nbin=int(r/deltar)+1

  if(nbin.le.maxbin) then
  nhist(nbin)=nhist(nbin)+1
  end if

  end do
  end if
 end do
end do


  c1=(4.0/3.0)*pi*rho

  !write(*,*) 'Ingrese nombre de la g(r)'
  !read *, nombre

! Archivo para guardar la gdr
  open (1, file = 'gr95.dat')

! Calculamos la gdr
  do nbin=1,maxbin

  rl=real(nbin-1)*deltar  !radio inferior
  ru=rl+deltar            !radio superior
  rt= rl+deltar/2.0       !distancia media
  Ngi=c1*(ru*ru*ru - rl*rl*rl)  !Para el gas ideal
  Nsis=real(nhist(nbin))/(real(M1)*real(N)) !Para el sistema
  gr=Nsis/Ngi

! Primer valor diferente de cero en grd (para calcular p)
  if (nbin.eq.ng) then
  gr1=gr
  r1=rt
  end if

! Valor de la gdr en Lambda
  if (nbin.eq.maxr) then
  grlam=gr
  rlam=rt
  end if

  write(1,*) rt, gr

  integrando(nbin)=gr*rt*rt

  end do

! Integración por trapecio para a
  inta=(1.0/2.0)*(gr1*r1*r1+grlam*rlam*rlam)

  do k=ng+1,maxr-1
  inta=inta+integrando(k)
  end do

  inta=deltar*inta

! Integración por trapecio para P
  inte=(1.0/2.0)*rcut*rcut

  do i=2, maxbin-1
  inte=inte + integrando(i)
  end do

  inte=deltar*inte

  NRcut=24.0*rho*inte

! Coeficientes a* y b* de Van der Waals
  b=(2.0/3.0)*pi*gr1
  a1=((2.0*pi)/1.0)*inta
  a74=((2.0*pi)/0.74)*inta

! Calculamos la presión de esferas duras

  p=rho*(1.0+rho*b)

! Y la presión de esferas duras de Carnahan-Starling

  pcs1=(1.0+phi+phi**2.0-phi**3.0)*rho
  pcs2=(1.0-phi)**3.0
  pcs=pcs1/pcs2

 write(*,*) '======================================================='
 write(*,*) 'n*, phi, PHS, PCS, GR1, b, a1, a74'
 write(*,*) rho, phi, p, pcs, gr1, b, a1, a74 
 write(*,*) 'El numero  de parti�culas es', N
 write(*,*) 'El numero de parti�culas calculado es', NRcut
 write(*,*) '======================================================='

 close(1)

 deallocate(integrando)
 deallocate(nhist)

return
end
