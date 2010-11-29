#include <gsl/gsl_siman.h>


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
		      double* ry ); 
