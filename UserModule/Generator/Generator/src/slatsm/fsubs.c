#include <string.h>
#include <stdlib.h>

/* System call from fortran */
#ifndef CRAY2
#ifdef CRAY
void FSYSTM(ps,res)
char *ps; long *res;
{
  int len=strlen(ps);
#else
#if HP | AIX
void fsystm(ps,res,len)
#else
void fsystm_(ps,res,len)
#endif
#if SGI8
int len; int *res; char *ps;
#else
int len; long *res; char *ps;
#endif
{
#endif
  char *copy = (char *) malloc (len + 1);
  strncpy(copy,ps,len);
  if (copy[len-1] != '\0') copy[len] = 0;
#if SGI8
  *res = system(copy);
#else
  *res = (long) system(copy);
#endif
  free (copy);
}

#else
#include <fortran.h>
#include <stdio.h>

void FSYSTM(ps,res)
  _fcd ps; long *res;
{
  int len;  char *ps2;
  char	*cstring;

  len = _fcdlen(ps);
  cstring = malloc(len+1);
  strncpy(cstring, _fcdtocp(ps), len);

  ps2 = malloc(len+1);
  strncpy(ps2,cstring,len);
  if (ps2[len-1] != '\0') ps2[len] = 0;
  *res = (long) system(ps2);
  free (ps2);

  free (cstring);
}

#endif

#include <ctype.h>
#include <stdio.h>

/* Writes string s[i1..i2] to stdout */
#define min(a,b) (((a) < (b)) ? (a) : (b))
#ifdef CRAY
void CWRITE(ps,i1,i2,nwlin)
char *ps; int *i1,*i2,*nwlin;
{
  register i; int len;
  len = strlen(ps);
  for (i = *i1-1 ; ++i <= min(*i2,len) ; putchar(ps[i]));
  if (*nwlin) { putchar('\n'); } else {fflush(stdout);}
}
#else
#if HP | AIX
void cwrite(ps,i1,i2,nwlin,len)
#else
void cwrite_(ps,i1,i2,nwlin,len)
#endif
char *ps; int *i1,*i2,*nwlin,len;
{
  register int i;
  for (i = *i1-1 ; ++i <= min(*i2,len) ; putchar(ps[i]));
  if (*nwlin) { putchar('\n'); } else {fflush(stdout);}
}
#endif

/* flushes stdout if iout >=0, else flushes all buffers */
#define min(a,b) (((a) < (b)) ? (a) : (b))
#ifdef CRAY
void FLUSHS(iout)
#else
#if HP | AIX
void flushs(iout)
#else
void flushs_(iout)
#endif
#endif
int *iout;
{ if (*iout >= 0) fflush(stdout); if (*iout < 0) fflush(NULL);}

/* returns bitwise AND of two integers */
#ifdef CRAY
int BITAND(i1,i2)
int *i1,*i2;
{ return (*i1 & *i2);}
#else
#if HP | AIX
int bitand(i1,i2)
int *i1,*i2;
{ return (*i1 & *i2);}
#else
int bitand_(i1,i2)
int *i1,*i2;
{ return (*i1 & *i2);}
#endif
#endif

/* returns bitwise OR of two integers */
#ifdef CRAY
int BITOR(i1,i2)
int *i1,*i2;
{ return (*i1 | *i2);}
#else
#if HP | AIX
int bitor(i1,i2)
int *i1,*i2;
{ return (*i1 | *i2);}
#else
int bitor_(i1,i2)
int *i1,*i2;
{ return (*i1 | *i2);}
#endif
#endif


/* Returns newline or one of collection of special characters:
   ich=1 => newline char */
#define min(a,b) (((a) < (b)) ? (a) : (b))
#ifdef CRAY
void NLCHAR(ich,ps)
int *ich; char *ps;
{
  if (*ich == 1) *ps = '\n';
}
#else
#if HP | AIX
void nlchar(ich,ps,len)
#else
void nlchar_(ich,ps,len)
#endif
char *ps; int *ich,len;
{
  if (*ich == 1) *ps = '\n';
}
#endif

/* Converts string to lower case */
#ifndef CRAY2
#ifdef CRAY
void LOCASE(ps)
char *ps;
{
  int i,len;
  len = strlen(ps);
/*  printf("case: %d %s\n",len,ps); */
  for (i = -1 ; ++i<len ; ps++) if (isupper(*ps)) *ps = tolower(*ps);
}

#else

#if HP | AIX
void locase(ps,len)
#else
void locase_(ps,len)
#endif
int len; char *ps;
{
  int i;

/*  printf("case: %d %s\n",len,ps); */
  for (i = -1 ; ++i<len ; ps++) if (isupper(*ps)) *ps = tolower(*ps);
}

#endif
#else
/**************************************************************/
/* This routine converts a fortran string into lower case.    */
/* It is called from a fortran program as:                    */
/*   CALL LOCASE(string)                                      */
/* _fcd is a fortran character descriptor type.               */
/* _fcdlen gets the length of a fortran character descriptor. */
/* _fcdtocp converts a fortran character descriptor into      */
/*   a c character pointer.				      */
/**************************************************************/

#include <fortran.h>
#include <stdio.h>

void LOCASE(ps)
  _fcd	ps;
{

  int	i, len;
  char	*cstring;

/* Get the length of the string. */
  len = _fcdlen(ps);

/* Copy the fortran string into a c string. */
  cstring = malloc(len+1);
  strncpy(cstring, _fcdtocp(ps), len);

/* Convert the c string to lower case. */
  for (i=0; i<len; i++)
    if (isupper(cstring[i])) cstring[i] = tolower(cstring[i]);

/* Copy the c string back into the fortran string. */
  strncpy(_fcdtocp(ps), cstring, len);
  free (cstring);

}

#endif


/* Returns an ascii string with the date and time, Fortran style */
#include <sys/time.h>

#ifndef CRAY2
#ifdef CRAY
void FTIME(ps)
char *ps;
{
  struct timeval  tp;
  struct timezone tzp;
  int tlen,len;
  len = strlen(ps);

#else

#if HP | AIX
void ftime(ps,len)
#else
void ftime_(ps,len)
#endif
int len; char *ps;
{
  struct timeval  tp;
  struct timezone tzp;
  int tlen;

#endif
  for (tlen = -1; ++tlen<len; ps[tlen] = ' ');

  tlen = (25 > len) ? len: 25;
  gettimeofday( &tp, &tzp);
  strncpy(ps,ctime(&(tp.tv_sec)),tlen); if (tlen == 25) ps[24]= ' ';

#else
#include <fortran.h>
#include <stdio.h>

void FTIME(ps)
  _fcd	ps;
{
  struct timeval  tp;
  struct timezone tzp;
  int tlen,len;
  char	*cstring;

  len = _fcdlen(ps);
  cstring = malloc(len+1);
  strncpy(cstring, _fcdtocp(ps), len);

  for (tlen = -1; ++tlen<len; ps[tlen] = ' ');

  tlen = (25 > len) ? len: 25;
  gettimeofday( &tp, &tzp);
  strncpy(cstring,ctime(&(tp.tv_sec)),tlen);
  if (tlen == 25) cstring[24]= ' ';

  strncpy(_fcdtocp(ps), cstring, len);
  free (cstring);

#endif

/*
  printf("%d\n",gettimeofday( &tp, &tzp));
  printf("%d\n",tp.tv_sec);
  printf("%s",ctime(&(tp.tv_sec)));
  printf("%sQ",ps);
  exit();
*/
}

/* Returns the time in seconds and microseconds since midnight,
   Jan 1, 1970 */
#include <sys/time.h>

#if HP | AIX
void sectim(tsec,tusec)
#else
#if CRAY
void SECTIM(tsec,tusec)
#else
void sectim_(tsec,tusec)
#endif
#endif
int *tsec, *tusec;
{
  struct timeval  tp;
  struct timezone tzp;

  gettimeofday( &tp, &tzp);
  *tsec = (int) tp.tv_sec;  *tusec = (int) tp.tv_usec;
}

/* gtenv is intended to be portable, fortran-callable routine to
   get an environment variable.  Trailing blanks in the environment
   variable are truncated.  pnam and pval may point to the same address.
*/
#ifdef CRAY
void GTENV (pnam,pval)
char *pnam, *pval;
{
  int len = strlen(pnam); int lval = strlen(pval);
#else
#if HP | AIX
void gtenv (pnam,pval,len,lval)
#else
void gtenv_ (pnam,pval,len,lval)
#endif
char *pnam, *pval; int len,lval;
{
#endif
/* use these to check validity of hidden fortran length args len,lval:
  printf("case: %d %s\n",len,pnam);
  printf("case: %d %s\n",lval,pval);
*/
  char *ps; size_t lenv;
  char *copy = (char *) malloc (len + 1);
  { int k = len;
    strncpy(copy,pnam,len);
    while (copy[--k] == ' ');
    copy[++k] = '\0';
  }
  ps = getenv (copy);
  if (ps) strcpy(pval,ps);
  else { register int k = lval; while (k--) pval[k] = ' '; }
  free (copy);
  if ((lenv=strlen(pval)) < lval) pval[lenv] = ' ';

/*  printf("case: %d %s\n",strlen(pval),pval); */
}

/* ptenv is intended to be portable, fortran-callable routine to
   put an environment variable.  Syntax pnam=val.
*/
#ifdef CRAY
void PTENV (pnam)
char *pnam
{
  int len = strlen(pnam);
#else
#if HP | AIX
void ptenv (pnam,len,lval)
#else
void ptenv_ (pnam,len,lval)
#endif
char *pnam; int len,lval;
{
#endif
/* use these to check validity of hidden fortran length args len,lval:
  printf("case: %d %s\n",len,pnam);
*/
  char *copy = (char *) malloc (len + 1);
  { int k = len;
    strncpy(copy,pnam,len);
    while (copy[--k] == ' ');
    copy[++k] = '\0';
  }
/*   printf("case: %d %s\n",len,copy); */
  putenv (copy);
}

/* faloc is intended to be portable, fortran-callable memory allocator.
   It is useful only for fortran compilers with pointer capability.
   faloc allocates memory for, initializes, and returns a pointer to,
   an array of length n and cast depending on type:
   type: 0=logical, 1=char, 2=int, 3=real, 4=double
*/
#ifdef CRAY
void FALOC (pd,type,n)
#else
#if HP | AIX
void faloc (pd,type,n)
#else
void faloc_ (pd,type,n)
#endif
#endif

double **pd; int *n, *type;
{
  int j; *pd = 0;
  switch (*type)
    { case 0: j = sizeof(int);    break;
      case 1: j = sizeof(char);   break;
      case 2: j = sizeof(int);    break;
      case 3: j = sizeof(float);  break;
      case 4: j = sizeof(double); break;
      default: j = 0;
    }
  {int jj;
   jj = 1 + j/sizeof(double);
   jj = 1 + jj;}

  *pd = (double *) calloc ( *n * j/sizeof(double) + 1, sizeof(double) ) ;

}

/* shift and copy a vector represented by a pointer to another vector
   ptr pointer to a vector pointer
   vec pointer to a vector
   nel size of vector
   np  first element in ptr
   nv  first element in vec
   io  1 copy from ptr to vec
      -1 copy from vec to ptr
*/
#ifdef CRAY
void PTRCOP (ptr, vec, nel, np, nv, fac, io)
#else
#if HP | AIX
void ptrcop (ptr, vec, nel, np, nv, fac, io)
#else
void ptrcop_ (ptr, vec, nel, np, nv, fac, io)
#endif
#endif
double **ptr, *vec, *fac; int *nel, *np, *nv, *io;
{
  int i;  double *afrom, *ato;

  switch (*io)
    { case  1: afrom = *ptr + *np - 1; ato =  vec + *nv - 1;  break;
      case -1: afrom =  vec + *nv - 1; ato = *ptr + *np - 1;  break;

#ifdef CRAY
      default: RXI ("ptrcop: bad io,", io, 15L);
#else
#if HP | AIX
      default: rxi ("ptrcop: bad io,", io, 15L);
#else
      default: rxi_("ptrcop: bad io,", io, 15L);
#endif
#endif
    }

  if (*fac != 1.) {for (i = 1; i <= *nel; ++i) {ato[i] = *fac * afrom[i];}}
  else {for (i = 0; i < *nel; ++i) 
  {
/*    printf("ato, afrom %d %d %f %f\n",*nel,i,ato[i],afrom[i]); */
    ato[i] = afrom[i];}}
}

#ifdef AIX
#include <sys/signal.h>
/*
 * This routine is intended to work around an annoying misfeature
 * in AIX when the paging space is nearly full.  When the paging
 * space nearly fills up, AIX sends SIGDANGER to all non-kernel
 * processes in a normal state. (The default is to ignore this
 * signal.) If things get really bad, then the youngest process that
 * is non-kernel, not catching SIGDANGER, not a zombie, and not
 * being killed is blown away with a SIGKILL. (youngest == largest
 * value of u_start in the user structure) This is repeated until
 * enough free space is available.  The upshot of this is that if
 * a process catches SIGDANGER, it will not be killed -- but if too
 * many processes do this, then the system may well crash...
 *
 * This routine (save_me) simply declares a do-nothing handler for
 * the SIGDANGER signal in order to avoid being blown away.
 */

void on_intr_do_nothing()
{
/* Do nothing */
}


void save_me()
{
  struct sigaction action;

  action.sa_handler = on_intr_do_nothing;
  action.sa_flags = 0;
  sigemptyset(&action.sa_mask);
  sigaction( SIGDANGER, &action, NULL);
}
#endif


#include <limits.h>
#include <float.h>
#include <math.h>
#ifdef CRAY
void MKDCON(dmach, d1mach)
double *dmach, *d1mach;
#else
#if HP | AIX
void mkdcon(dmach, d1mach)
double *dmach, *d1mach;
#else
void mkdcon_(dmach, d1mach)
double *dmach, *d1mach;
#endif
#endif

/* Make double precision constants using the machine constants
   found in <limits.h> and <float.h>.

   dmach[0-2] are as returned by the BLAS subroutine dmach and are
   defined as follows.
        b = base of arithmetic
        t = number of base b digits
        l = smallest possible exponent
        u = largest possible exponent
   dmach[0]: eps = b**(1-t)
   dmach[1]: tiny = 100.0*b**(-l+t)
   dmach[2]: huge = 0.01*b**(u-t)

   d1mach[0-4] are as returned by the BLAS subroutine d1mach and are
   defined as follows.
   d1mach[0] = b**(l-1), the smallest positive magnitude.
   d1mach[1] = b**(u*(1 - b**(-t))), the largest magnitude.
   d1mach[2] = b**(-t), the smallest relative spacing.
   d1mach[3] = b**(1-t), the largest relative spacing.
   d1mach[4] = log10(b)
*/

{
  double eps, ubt, bubt;
  int t, b, l, u;
  
  b = FLT_RADIX;
  eps = DBL_EPSILON;
  l = DBL_MIN_EXP;
  u = DBL_MAX_EXP;

  t = (int)(1-(log(eps)/log((float)b)));

  dmach[0] = pow((float)b,(float)(1-t));
  dmach[1] = 100*pow((float)b,(float)(l+t));
  dmach[2] = pow((float)b,(float)(u-t))/100.0;

  d1mach[0] = pow((float)b,(float)(l-1));
  ubt = ((float)u*(1.0-pow((float)b,-(float)t)));
  bubt = b*pow((float)b,(ubt-1.0));
  d1mach[1] = bubt;
  d1mach[2] = pow((float)b,-(float)t);
  d1mach[3] = pow((float)b,(float)(1-t));
  d1mach[4] = log((float)b)/log(10.0);
}
