/* Main and support programs to link unix shell with fortran programs.
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef MPI
#include "mpi.h"
#define MAXARGS 100
#endif

static int ret_val=0, aargc;
static char **pargv;

#if ( LINUXI | LINUXA | LINUXF )
void MAIN__()
#endif
#ifdef LINUX_PGI
void MAIN_(argc,argv)
short argc; char *argv[];
#endif
#ifdef LAHEY_LF95
void MAIN__(argc,argv)
short argc; char *argv[];
#endif
#if !(LINUX)
void main(argc,argv)
short argc; char *argv[];
#endif
{
#ifdef CRAY
  void FMAIN();
#endif
#if HP | AIX
  void fmain();
#endif
#if !(HP | AIX | CRAY)
  void fmain_();
#endif

#ifdef MPI
  char *argv_copy[MAXARGS];
  size_t bytes;
  int len, i, procid, master;
  aargc = argc;
  MPI_Init(&aargc,&argv);
  MPI_Comm_rank(MPI_COMM_WORLD,&procid);
  master = 0;
  MPI_Bcast(&aargc,1,MPI_INT,master,MPI_COMM_WORLD);
  for (i = 0; i < aargc; i++) {
    if (procid == master) {
      len = 1 + strlen(argv[i]);
    }
    MPI_Bcast(&len,1,MPI_INT,0,MPI_COMM_WORLD);
    bytes = len * sizeof(char);
    if ( !(argv_copy[i] = malloc(bytes)) ) {
      printf("Process %d: unable to allocate %d bytes\n",procid,bytes);
      exit(-1);
    }
    strcpy(argv_copy[i], argv[i]);
    MPI_Bcast(argv_copy[i],len,MPI_CHAR,master,MPI_COMM_WORLD);
  }
  pargv = argv_copy;
#endif

#if !(LINUXI | LINUXA | LINUXF)
  aargc = argc;
  pargv = argv;
#endif
#ifdef CRAY
   FMAIN();
#endif
#if (HP | AIX)
#ifdef AIX
   save_me();  /* so we won't get killed when page space is low */
#endif
   fmain();
#endif
#if !(HP | CRAY | AIX)
   fmain_();
#endif
  exit (ret_val);
}

#ifdef CRAY
void CEXIT(pv,ps)
#endif
#if (HP | AIX)
void cexit(pv,ps)
#endif
#if !(HP | CRAY | AIX)
void cexit_(pv,ps)
#endif
int *pv,*ps;
{
  ret_val = *pv;
#ifdef CRAY2
  exit (ret_val);
#else
  if (*ps) exit (ret_val);
#endif
}

#ifdef CRAY
int NARGC()
#endif
#if (HP | AIX)
int nargc()
#endif
#if !(HP | CRAY | AIX)
int nargc_()
#endif
{
#if (LINUXI | LINUXA | LINUXF | LINUX)
  int i,iargc_();
  return(iargc_()+1);
#else
  return(aargc);
#endif
}

/* A fortran-callable 'getarg'.  Originally called 'getarg' but
  the HP f90 compiler links in its own library routine before getarg,
  but does not return command line arguments.

  The linux compilers don't start with C main; and argc and argv
  above are not passed.  In that case, the system call to getarg works
  and we use that.
*/

#if ! (LINUXI | LINUXA | LINUXF)
#if (HP | AIX)
void gtargc(iarg,ps,len)
#else
void gtargc_(iarg,ps,len)
#endif
int *iarg; char *ps; short len;
{
  int i,maxlen; char *pps;

/* to handle fortran bug ... */
  len = (len < 0) ? -len : len;

  if (*iarg > aargc)
    { puts("getarg: request for nonexistent command line arg");
      exit(-1);
    }

/*copy string to ps, filling with blanks if passed string longer ...*/
  maxlen = strlen(*(pargv + *iarg));
  maxlen = (maxlen < len) ? maxlen : len;
  for (i = -1, pps=ps ; ++i<maxlen ;) *pps++ = *(*(pargv + *iarg) + i);
  while (i < len) {*pps++ = ' '; i++;}

}
#endif

/* void fmain() { void ftime(); printf("hello, world"); ftime();} */

#if DEC
void s_abort()
{
  exit(-1);
}
#endif
