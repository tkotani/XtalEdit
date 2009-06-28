C Workaround Portland group pgf90 compiler; line routines from slatsm
C#ifdefC LINUX_PGI
C      subroutine nada
C      double precision xx,dlamch
C      xx = 2*dlamch('S')
C      if (xx .eq. 99) CALL XERBLA( 'DGEMM ', 0 )
C      end
C#else
      subroutine nada
      end
C#endif
