{-# LANGUAGE ForeignFunctionInterface, BangPatterns #-}

--
-- Ugly code using global state but this is the fastest way. 
--

--
--
--

module HEP.Minimizer.GSLSimulatedAnnealing.Annealing where

import Foreign
import Foreign.Ptr
import Foreign.C.Types

#include "simann.h"

type CFunc1D = CDouble -> Ptr () -> CDouble
type CFunc2D = CDouble -> CDouble -> Ptr () -> CDouble
type CFunc2D2D = CDouble -> CDouble -> CDouble -> CDouble -> Ptr () -> CDouble


-- | argument :  x, y, E1, S1, M1, N_TRIES, ITERS_FIXED_T, STEP_SIZE, 
--               K, T_INITIAL, MU_T, T_MIN
--   and return (rx,ry) as the last pointer argument 

foreign import ccall "simann.h siman_solve_2d" c_siman_solve_2d
  :: CDouble -> CDouble 
     -> (FunPtr CFunc2D) -> (FunPtr CFunc2D2D) 
     -> CInt -> CInt -> CDouble -> CDouble -> CDouble -> CDouble -> CDouble 
     -> (Ptr CDouble) -> (Ptr CDouble)
     -> IO () 
  
makeCfunc1D :: (Double -> Double) -> (CDouble -> Ptr () -> CDouble)
makeCfunc1D  f = \x voidpointer -> realToFrac $ f (realToFrac x)
                     
makeCfunc2D :: ((Double, Double) -> Double) 
               -> (CDouble -> CDouble -> Ptr () -> CDouble)
makeCfunc2D f !x !y !voidpointer =  realToFrac $ f (realToFrac x, realToFrac y) 
 {- \x y voidpointer -> -}
                                    
                                    
makeCfunc2D2D :: ((Double, Double) -> (Double, Double) -> Double) 
               -> (CDouble -> CDouble -> CDouble -> CDouble -> Ptr () -> CDouble)
makeCfunc2D2D f = \x y z w voidpointer -> 
  realToFrac $ f (realToFrac x, realToFrac y) (realToFrac z, realToFrac w) 



foreign import ccall "wrapper"
  makeFunPtr1D :: CFunc1D -> IO (FunPtr CFunc1D)
                  
foreign import ccall "wrapper"
  makeFunPtr2D :: CFunc2D -> IO (FunPtr CFunc2D)                  

foreign import ccall "wrapper"
  makeFunPtr2D2D :: CFunc2D2D -> IO (FunPtr CFunc2D2D)