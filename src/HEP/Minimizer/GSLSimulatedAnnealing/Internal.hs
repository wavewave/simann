{-# LANGUAGE ScopedTypeVariables #-}

module HEP.Minimizer.GSLSimulatedAnnealing.Internal where

import Foreign
import Foreign.Ptr
import Foreign.C.Types

import HEP.Minimizer.GSLSimulatedAnnealing.Type
import HEP.Minimizer.GSLSimulatedAnnealing.Annealing

simanSolve2d :: (Double,Double) 
                -> SimulatedAnnealingFunction2D 
                -> SimulatedAnnealingParam 
                -> IO (Double,Double)
simanSolve2d (x,y) safunc2d saparam = do 
  let e1 = makeCfunc2D   $ safunc2d'energy safunc2d
--      s1 = makeCfunc2D2D $ safunc2d'step safunc2d
      m1 = makeCfunc2D2D $ safunc2d'measure safunc2d
      
  e1ptr <- makeFunPtr2D   e1
--s1ptr <- makeFunPtr2D2D s1
  m1ptr <- makeFunPtr2D2D m1
  
  let cx = realToFrac x
      cy = realToFrac y 
      n_tries       = fromIntegral $ saparam'n_tries      saparam
      iters_fixed_t = fromIntegral $ saparam'iters_fixed_t saparam
      step_size     = realToFrac   $ saparam'step_size    saparam
      k             = realToFrac   $ saparam'k            saparam
      t_initial     = realToFrac   $ saparam't_initial    saparam
      mu_t          = realToFrac   $ saparam'mu_t         saparam
      t_min         = realToFrac   $ saparam't_min        saparam
  
  alloca $ \rx -> 
    alloca $ \ry -> do 
      c_siman_solve_2d cx cy e1ptr m1ptr 
        n_tries iters_fixed_t step_size k t_initial mu_t t_min rx ry
      xfinal <- peek rx
      yfinal <- peek ry 
      return (realToFrac xfinal, realToFrac yfinal) 
                    

simanSolve2d':: (Double,Double) 
                 -> SimulatedAnnealingFunction2D' 
                 -> SimulatedAnnealingParam 
                 -> IO (Double,Double)
simanSolve2d' (x,y) safunc2d saparam = do 
  let e1 = safunc2d''energy safunc2d
      m1 = makeCfunc2D2D $ safunc2d''measure safunc2d
      
  e1ptr <- makeFunPtr2D   e1
  m1ptr <- makeFunPtr2D2D m1
  
  let cx = realToFrac x
      cy = realToFrac y 
      n_tries       = fromIntegral $ saparam'n_tries      saparam
      iters_fixed_t = fromIntegral $ saparam'iters_fixed_t saparam
      step_size     = realToFrac   $ saparam'step_size    saparam
      k             = realToFrac   $ saparam'k            saparam
      t_initial     = realToFrac   $ saparam't_initial    saparam
      mu_t          = realToFrac   $ saparam'mu_t         saparam
      t_min         = realToFrac   $ saparam't_min        saparam
  
  alloca $ \rx -> 
    alloca $ \ry -> do 
      c_siman_solve_2d cx cy e1ptr m1ptr 
        n_tries iters_fixed_t step_size k t_initial mu_t t_min rx ry
      xfinal <- peek rx
      yfinal <- peek ry 
      return (realToFrac xfinal, realToFrac yfinal) 
