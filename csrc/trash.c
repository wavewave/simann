#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <gsl/gsl_siman.h>

/* set up parameters for this simulated annealing run */

/* how many points do we try before stepping */
#define N_TRIES 200             

/* how many iterations for each T? */
#define ITERS_FIXED_T 1000

/* max step size in random walk */
#define STEP_SIZE 1.0            

/* Boltzmann constant */
#define K 1.0                   

/* initial temperature */
#define T_INITIAL 0.008         

/* damping factor for temperature */
#define MU_T 1.03             
#define T_MIN 2.0e-6

gsl_siman_params_t params 
= {N_TRIES, ITERS_FIXED_T, STEP_SIZE,
   K, T_INITIAL, MU_T, T_MIN};

/* now some functions to test in one dimension */
double E1(void *xp)
{
  double *xarr = (double *) xp;
  double x = xarr[0] ; 
  double y = xarr[1]; 
  
  return exp(-pow((x-1.0),2.0) - pow((y-1.0),2.0))*sin(8*x)*cos(8*y);
}

double M1(void *xp, void *yp)
{
  double *xarr = (double *) xp;
  double x1 = xarr[0]; 
  double x2 = xarr[1];

  double *yarr = (double *) yp; 
  double y1 = yarr[0]; 
  double y2 = yarr[1];

  return (x1-y1)*(x1-y1) + (x2-y2)*(x2-y2);
}

void S1(const gsl_rng * r, void *xp, double step_size)
{
  double *xarr = (double *) xp; 
  double old_x = xarr[0];
  double old_y = xarr[1];
  double new_xarr[2];
  
  double ux = gsl_rng_uniform(r);
  double uy = gsl_rng_uniform(r); 

  new_xarr[0] = ux * 2 * step_size - step_size + old_x;
  new_xarr[1] = uy * 2 * step_size - step_size + old_y;
  
  
  memcpy(xp, new_xarr, sizeof(double)*2);
}

void P1(void *xp)
{
  double *xarr = (double*) xp ;
  printf ("%12g %12g", xarr[0] , xarr[1] );
}

int
main(int argc, char *argv[])
{
  const gsl_rng_type * T;
  gsl_rng * r;
  
  double x_initial[2] = {15.5, -10.3};

  
  gsl_rng_env_setup();
  
  T = gsl_rng_default;
  r = gsl_rng_alloc(T);
  
  gsl_siman_solve(r, &x_initial, E1, S1, M1, P1,
		  NULL, NULL, NULL, 
		  sizeof(double)*2, params);
  
  gsl_rng_free (r);
  return 0;
}
