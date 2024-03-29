module allen
use vars
use maths
implicit none

contains
!------------------------------------------------------------
! Read Allen's data
!------------------------------------------------------------
	subroutine read_allen_data
	integer :: i, j
			
		open(unit=12, file='CLV/ic.dat', action='read', status='old')
		do i = 1, 43
			read(12, *) (allen_ic(i, j), j=1, 2)
		enddo
		close(12)

! Units conversion
		allen_ic(:, 2) = allen_ic(:, 2) * allen_ic(:, 1)**2 / (PC*1.d4) ! i_lambda to i_nu
		allen_ic(:, 1) = 1d4 * allen_ic(:, 1)  ! wavelength in angstrom

! Reading data file with coefficients for centre-to-limb variation
!      first column: wavelength in microns
!      2nd & 3rd columns: u & v coefficients where
!         i(mu)/i(0) = 1 - u - v + u \mu + v \mu^2
		open(unit=12, file='CLV/cl.dat', action='read', status='old')
      do i = 1, 22
			read(12, *) (allen_cl(i, j), j=1, 3)
      enddo
      close(12)

      allen_cl(:, 1) = 1d4 * allen_cl(:, 1)  ! wavelength in angstrom
		
	end subroutine read_allen_data
	
!------------------------------------------------------------
! Return the nbar parameter from Allen's data
!------------------------------------------------------------
	function nbar_allen(lmb, in_fixed, in_params, reduction_factor)
	type(fixed_parameters) :: in_fixed
	type(variable_parameters) :: in_params
	real(kind=8) :: lmb, height, nbar_allen, l(1), t(1), delta, reduction_factor
	integer :: i
	real(kind=8) :: u1, u2, I0, sg, cg, a0, a1, a2, b0, b1, b2, J, K

		l(1) = lmb
		call lin_interpol(allen_ic(:,1), allen_ic(:,2), l, t)
		I0 = t(1)
		call lin_interpol(allen_cl(:,1), allen_cl(:,2), l, t)
		u1 = t(1)
		call lin_interpol(allen_cl(:,1), allen_cl(:,3), l, t)
		u2 = t(1)
		
! Take into account the observation angle (scattering angle) to calculate the height from the apparent height
! Only do this if we use the apparent height
		if (in_params%height < 0.d0) then
			delta = abs(90.d0 - in_fixed%thetad)
			height = (RSUN + in_params%height) / (cos(delta*PI/180.d0)) - RSUN
		else
			height = abs(in_params%height)
		endif

		if (height /= 0.d0) then
      	sg = Rsun / (height+Rsun)
      	cg = sqrt(1.d0-sg**2)

      	a0 = 1.d0 - cg
      	a1 = cg - 0.5d0 - 0.5d0*cg**2/sg*log((1.d0+sg)/cg)
      	a2 = (cg+2.d0)*(cg-1.d0) / (3.d0*(cg+1.d0))
		else
			a0 = 1.d0
			a1 = -0.5d0
			a2 = -2.d0 / 3.d0
		endif
        
		J = 0.5d0 * I0 * (a0 + a1*u1 + a2*u2)

		nbar_allen = 1d10*(lmb**3*1d-24/(2d0*ph*pc)) * J * reduction_factor
		
	end function nbar_allen
	
!------------------------------------------------------------
! Return the anisotropy parameter from Allen's data
! Reduction factor affects only the calculation of J00
!------------------------------------------------------------
	function omega_allen(lmb, in_fixed, in_params, reduction_factor)
	type(fixed_parameters) :: in_fixed
	type(variable_parameters) :: in_params
	real(kind=8) :: lmb, height, omega_allen, l(1), t(1), delta, reduction_factor
	integer :: i
	real(kind=8) :: u1, u2, I0, sg, cg, a0, a1, a2, b0, b1, b2, J, K

		l(1) = lmb
		call lin_interpol(allen_ic(:,1), allen_ic(:,2), l, t)
		I0 = t(1)
		call lin_interpol(allen_cl(:,1), allen_cl(:,2), l, t)
		u1 = t(1)
		call lin_interpol(allen_cl(:,1), allen_cl(:,3), l, t)
		u2 = t(1)
		
	
! Take into account the observation angle (scattering angle) to calculate the height from the apparent height
! Only do this if we use the apparent height
		if (in_params%height < 0.d0) then
			delta = abs(90.d0 - in_fixed%thetad)
			height = (RSUN + in_params%height) / (cos(delta*PI/180.d0)) - RSUN
		else
			height = abs(in_params%height)
		endif
		
      if (height /= 0) then
			sg = Rsun / (height+Rsun)
      	cg = sqrt(1.d0-sg**2)

      	a0 = 1.d0 - cg
      	a1 = cg - 0.5d0 - 0.5d0*cg**2/sg*log((1.d0+sg)/cg)
      	a2 = (cg+2.d0)*(cg-1.d0) / (3.d0*(cg+1.d0))

      	b0 = (1.d0-cg**3) / 3.d0
      	b1 = (8.d0*cg**3-3.d0*cg**2-2.d0) / 24.d0 - cg**4 / (8.d0*sg) * log((1.d0+sg)/cg)
      	b2 = (cg-1.d0)*(3.d0*cg**3+6.d0*cg**2+4.d0*cg+2.d0) / (15.d0*(cg+1.d0))
		else
			a0 = 1.d0
			a1 = -0.5d0
			a2 = -2.d0 / 3.d0
			
			b0 = 1.d0 / 3.d0
			b1 = -1.d0 / 12.d0
			b2 = -2.d0 / 15.d0
		endif
        
		J = 0.5d0 * I0 * (a0 + a1*u1 + a2*u2)
		K = 0.5d0 * I0 * (b0 + b1*u1 + b2*u2)

		omega_allen = (3.d0*K-J) / (2.d0*J) * reduction_factor
		
	end function omega_allen	
	
end module allen
