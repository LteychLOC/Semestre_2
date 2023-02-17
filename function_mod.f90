module function_mod

    use constantes_mod
    use appendices_mod

    implicit none


    contains
        function RHO_air_humide(Wa, Ta) result(res)
            real(PR), intent(in)     :: Ta, Wa
            real(PR)                 :: res
            res = Constante1_rho_air_humide * ((1._PR+Wa)/(Constante2_rho_air_humide+ Wa)*Ta)
        end function

        function RHO_air_sec(Ta0, Hra0) result(res) ! masse volumique de l'air sec
            real(PR), intent(in)     :: Ta0, Hra0
            real(PR)                 :: res
            res = (10._PR**(5) - Psat(Ta0)* Hra0*(10._PR**(-2))) / (287.1_PR * Ta0)
        end function

        function Ht(Wa,Ta) result(res)
            real(PR), intent(in)     :: Wa, Ta
            real(PR)                 :: res
            res = 175._PR*sqrt(Va * RHO_air_humide(Wa,Ta))
        end function

        function Lv(Tp) result(res)  ! chaleur latente de vaporisation
            real(PR), intent(in)     :: Tp
            real(PR)                 :: res

            res = 1000*(A5*(Tp - 273)**5 + A4 *(Tp -273)**4 + A3*(Tp-273)**3+ &
            & A2*(Tp -273)**2 + A1 * (Tp-273) +A0)
        end function

        function Weq(Wa, Tp) result(res)  ! elle fonctionne
            real(PR), intent(in)     :: Wa, Tp
            real(PR)                 :: res
            res= 0.01_PR *(-log(1._PR -(Pv(Wa)/Psat(Tp)))/ &
            &(2.31_PR*(Tp-273._PR + 55.815_PR)*(10._PR**(-5))))**(1._PR/2.29_PR)
            !invertion dans le log car - ln(a) = ln(1/a)

        end function

        function Pv(Wa) result(res)
            real(PR), intent(in)     :: Wa
            real(PR)                 :: res
            res = (100000._PR *Wa)/(Wa + 0.622_PR)
        end function


        function Psat(Ta) result (res) ! Pression saturante
            real(PR), intent(in)     :: Ta
            real(PR)                 :: res
            res = exp(54.119_PR - 6547.1_PR/Ta - 4.23_PR * log(Ta))
        end function

        function Diffusion(Tp) result (res)  ! coefficient de diffusion
            real(PR), intent(in)     :: Tp
            real(PR)                 :: res
            res = d * exp(c* (1._PR/Tp))
        end function

        subroutine variable (K,Tp,alpha, Wequi, Tpi)
            real(PR), intent(out) :: alpha,Wequi,K
            real(PR), intent(in)  :: Tp, Tpi

            Wequi = Weq(Wa0,Tp)
            K = ((Pi)*(Pi) * Kv**(2) * Diffusion(Tp)) / (9._PR)
            alpha = ((RHO_air_sec(Tp, Hra0)*Va*CPairSec)*(Tp - Tpi))/(Lv0*Rho_Produit_sec*(Wpi-Wequi))
        end subroutine variable

        !construction du modèle analytiques
        function Wp(x,t) result(res)
            real(PR), intent(in)     :: x, t
            real(PR)                 :: res
            real(PR)                 :: Wequi, alpha, K

            call variable (K, Ta0, alpha, Wequi, Tpi)

            res = Wequi + (exp(K*x/alpha)*(Wpi - Wequi))/&
            & (exp(K*x/alpha) + exp(K*t) - 1)
        end function

        function W(x,t) result(res)
            real(PR), intent(in)     :: x, t
            real(PR)                 :: res
            real(PR)                 :: alpha, K, Wequi

            call variable (K, Ta0, alpha, Wequi,Tpi)
            res = (exp(K*x/alpha))/(exp(K*x/alpha) + exp(K*t) - 1)
        end function









    ! inconnues sont Tp, Ta, Wp, Wa (teneur en eau)

end module function_mod
