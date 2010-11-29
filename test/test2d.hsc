{-# LANGUAGE ForeignFunctionInterface, BangPatterns #-}

module Main where 

import Foreign.Ptr
import Foreign.C.Types
import Foreign.C.Math.Double


#include "testc.h"


import HEP.Minimizer.GSLSimulatedAnnealing

foreign import ccall unsafe "testc.h func" c_test
  :: CDouble -> CDouble -> CDouble

param = SAParam { 
  saparam'n_tries       = 200, 
  saparam'iters_fixed_t = 1000, 
  saparam'step_size     = 1.0, 
  saparam'k             = 1.0,
  saparam't_initial     = 0.008, 
  saparam'mu_t          = 1.03, 
  saparam't_min         = 2.0e-6
  }
    
{- e1 :: (Double,Double) -> Double        
e1 (!x,!y) =  exp ( -(x-1.0)^2 - (y-1.0)^2) * sin (8.0*x) * cos (8.0*y) -}

  {- let cx = realToFrac x
                 cy = realToFrac y 
             in  realToFrac $ c_test cx cy -}
  
              
c_e1 :: CDouble -> CDouble -> Ptr () -> CDouble               
c_e1 x y _ = c_test x y 
  
  --  c_exp ( - (c_pow (x-1.0) 2.0) - (c_pow (y-1.0) 2.0)) * c_sin (8.0*x) * c_cos (8.0*y)

m1 :: (Double,Double) -> (Double,Double) -> Double
m1 (x1,y1) (x2,y2) = (x1-x2)^2 + (y1-y2)^2

        
func = SAFunc2D' { 
  safunc2d''energy = c_e1, 
  safunc2d''measure = m1
  }



main :: IO () 
main = do putStrLn "test simulated annealing 2d " 
          r <- simanSolve2d' (15.5, -10.3) func param
          putStrLn $ "result = " ++ (show r )