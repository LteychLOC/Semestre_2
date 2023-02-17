program sechage

    use constantes_mod
    use appendices_mod
    use function_mod

    implicit none

    real(PR) :: a, b, Tp !température variant pendant le temps
    real(PR) :: m_eau, m_air_sec,W_a_modif, Wamax, t, Wequi, alpha, K, X
    integer  :: i

    ! print*, log(3._PR) !valeur de ln en mathématique
    ! print*, Psat(20._PR)
    a = -2.6_PR*(10._PR**(-4))

    b = -0.00026_PR

    ! print*, a, b, Diffusion(20._PR +273.15_PR)
    ! print*, exp((-51080 * 1._PR)/(8.314* 45+273.15))

    m_eau =10
    m_air_sec =1

    print*, RHO_air_humide(Wa(m_eau, m_air_sec),Ta0) ! 71375

    print*, RHO_air_sec(Ta0, Hra0)


    print*, Wa(m_eau, m_air_sec)  ! nous obtenons bien 10
    ! ce n'est pas la bonne valeur pour calculer Weq
    print*, Pv(Wa(m_eau, m_air_sec))/ Psat(Ta0)
    print*, log((Pv(Wa(m_eau, m_air_sec))/Psat(Ta0))-1)
    print*, 2.31_PR*(Ta0-273+55.815_PR)*(10._PR**(-5))



    print*, "La valeur de la teneur en eau lorsque la teneur en eau de l'air = 0 :", Weq(0._PR, Ta0)
    print*, "La pression saturante de 273 =", Psat(273._PR)


    !nous avons Psat et le coefficient de diffusion qui sont environ égaux à 0

    ! Chaleur latente de vaporisation



    !"Etude des fonctions"

    Tp = 273
    ! open (unit=1, file= 'Resultats.dat')
    ! do i =0,100
    !     Tp=273 + i
    !     W_a_modif = (0.622_PR * Psat(Tp)/(100000._PR - Psat(Tp)))
    !     !valeurs définies pour un Wamax
    !     write(1,*) i, Tp, W_a_modif, Psat(Tp), Pv(W_a_modif), Diffusion(Tp)
    !
    ! end do
    !
    ! close(1)
    !
    ! open(unit=2, file='Calcul_de_Weq.dat') !Nous devons utliser la valeur de Tp dans Weq
    !                                         !pour avoir une valeur cohérente
    ! Tp = 308  ! Isotherme choisi à 35°C
    ! Wamax = ((0.622_PR * Psat(Tp))/(100000._PR - Psat(Tp)))
    ! print*, Wamax
    ! do i = 0,int( Wamax/0.0005_PR)
    !     t = i * 0.0005_PR
    !     write(2,*) t, Weq(t, Tp)
    ! end do
    ! close(2)
    !
    ! open(unit=3, file= 'Valeurs_Diffusion_pour_Tp_de_0_a_100000.dat')
    ! do i =0,int(100000._PR/100._PR)
    !     Tp= 274._PR + i*100_PR
    !     !valeurs définies pour un Wamax
    !     write(3,*) i, Tp, Diffusion(Tp)
    !
    ! end do
    !
    ! close(3)
    !
    ! open(unit=4, file= 'Valeurs_Pv_Psat_pour_T_fixe.dat')
    ! do i =0, 27
    !     Tp=273 + i
    !     !valeurs définies pour une température fixée de Pv et Pvsat
    !     Wamax = ((0.622_PR * Psat(284._PR))/(100000._PR - Psat(284._PR)))
    !     write(4,*) Tp, Psat(Tp) , Wamax, Pv(Wamax)
    !
    ! end do
    !
    ! close(4)



!Construction du modèle
! il se base sur les variation de la chaleur sensible de l'air due à l'humidité est négligeable
! Chaleur latente domine la chaleur sensilble

!Prenons par exemple une teneur en eau Wa0 à 10.

    ! print*, "La valeur de K(300) = ", K(300._PR)

    ! Solutions analytiques du modèle logarithmique

    ! Wequi=Weq(Wa0, Ta0)
    ! print*, "Valeur de Wequi =", Wequi


    ! call variable(K,Ta0,alpha,Wequi)
    ! print*, K,Ta0,alpha,Wequi


    print*, "Traçons maintenant l'évolution de la teneur en eau par rapport à l'évolution du temps ou de x"
    ! Wamax = ((0.622_PR * Psat(Ta0))/(100000._PR - Psat(Ta0)))



    open (unit= 6, file='Modelisation_Weq_avec_t_variable.dat')
    i = 0 !indice du temps pour avoir un écart plus petit que 0.001_PR
    X = 0._PR
    do while ((Wp(X,i *100._PR) - Wequi ) > 0.001_PR)
        i=i+1
        write(6,*) i*100, Wp(0._PR,i *100._PR), Wp (0.3_PR, i *100._PR), Wp(0.5_PR, i*100._PR)
    ! ce programe s'arrête lorsque t = 53 000 ce qui permet a Wp en x=0 d'être
    !à une précision de 10**(-2) par rapport à Wequi
    end do
    close(6)

    print*, "Traçons maintenant l'évolution de la teneur en eau par rapport à l'évolution du temps ou de x"
    ! Wamax = ((0.622_PR * Psat(Ta0))/(100000._PR - Psat(Ta0)))

    open (unit= 5, file='Modelisation_Weq_avec_t_variable.dat')
    i = 0  !indice du temps pour avoir un écart plus petit que 0.001_PR
    X = 1.0_PR
    do while ((Wp(0.8_PR,i *100._PR) - Wequi ) > 0.001_PR)
        i=i+1
        write(5,*) i*100, Wp(0._PR,i *100._PR), Wp (0.3_PR, i *100._PR), Wp(0.5_PR, i*100._PR)&
        &, Wp(0.8_PR, i*100.0_PR), Wp(X, i*100.0_PR)
    ! ce programe s'arrête lorsque t = 53 000 ce qui permet a Wp en x=0 d'être
    !à une précision de 10**(-2) par rapport à Wequi
    end do

    close(5)

    ! open (unit= 7, file='Variation_Wes_suivant_Wpi.dat')
    ! X = 1.0_PR  ! Représente Wa fixée
    ! do i= 0, 1000   ! Correspond à l_écoulement du temps
    !     write(7,*) i*100, Wp(X, i*100._PR, 0.6_PR), Wp(X, i*100._PR, 0.6_PR),&
    !     & Wp(X, i*100._PR, 0.7_PR), Wp(X, i*100._PR, 0.8_PR),&
    !     &Wp(X, i*100._PR, 0.9_PR), Wp(X, i*100._PR, 1.0_PR)
    ! end do
    ! close(7)


    ! open (unit= 8, file='Variation_Weq_suivant_Tpi.dat')
    ! !on voit pour chaque Ti différent pour voir le comportement de Wp
    ! X = 1.0_PR
    ! do i= 0, 1000
    !     write(8,*) i*100, Wp(X, i*100._PR, 273.15_PR), Wp(X, i*100._PR, 283.15_PR),&
    !     & Wp(X, i*100._PR, 293.15_PR), Wp(X, i*100._PR, 303.15_PR),&
    !     &Wp(X, i*100._PR, 313.15_PR)
    !
    ! end do
    !
    ! close(8)







end program sechage
