#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "simann.h"

void siman_solve_2d ( double x, double y, 
		      double e1(double, double), 
		      double m1(double, double, double, double),
		      int n_tries, 
		      int iters_fixed_t, 
		      double step_size, 
		      double k, 
		      double t_initial, 
		      double mu_t, 
		      double t_min, 
		      double* rx, 
		      double* ry) 
{
  gsl_siman_params_t params = { n_tries, iters_fixed_t, step_size, k, t_initial, mu_t, t_min };

  double E1(void *xp)
  {
    double *xarr = (double *) xp;
    double x = xarr[0] ; 
    double y = xarr[1]; 

    return e1(x,y) ; 
  }
  double M1(void *xp, void *yp)
  {
    double *xarr = (double *) xp;
    double x1 = xarr[0]; 
    double x2 = xarr[1];
    
    double *yarr = (double *) yp; 
    double y1 = yarr[0]; 
    double y2 = yarr[1];
  
    return m1(x1,x2,y1,y2) ; 
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
    //    double *xarr = (double*) xp ;
    // printf ("%12g %12g", xarr[0] , xarr[1] );
  }

  const gsl_rng_type * T;
  gsl_rng * r;
  
  double x_initial[2] = {x, y};
  
  
  gsl_rng_env_setup();
  
  T = gsl_rng_default;
  r = gsl_rng_alloc(T);
  
  gsl_siman_solve(r, &x_initial, E1, S1, M1, NULL,
		  NULL, NULL, NULL, 
		  sizeof(double)*2, params);

  *rx = x_initial[0]; 
  *ry = x_initial[1];
  
  gsl_rng_free (r);
  
  
} 

