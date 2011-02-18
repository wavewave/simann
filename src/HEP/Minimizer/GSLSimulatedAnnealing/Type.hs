module HEP.Minimizer.GSLSimulatedAnnealing.Type where

import Foreign.Ptr
import Foreign.C.Types

data SimulatedAnnealingParam = SAParam { 
  saparam'n_tries       :: Int, 
  saparam'iters_fixed_t :: Int, 
  saparam'step_size     :: Double, 
  saparam'k             :: Double, 
  saparam't_initial     :: Double, 
  saparam'mu_t          :: Double, 
  saparam't_min         :: Double
  }
                               
data SimulatedAnnealingFunction2D = SAFunc2D { 
  safunc2d'energy  :: (Double,Double) -> Double, 
 -- safunc2d'step    :: (Double,Double) -> (Double,Double) -> Double,
  safunc2d'measure :: (Double,Double) -> (Double,Double) -> Double
  }
                              
data SimulatedAnnealingFunction2D' = SAFunc2D' { 
  safunc2d''energy  :: CDouble -> CDouble -> Ptr () -> CDouble, 
  safunc2d''measure :: (Double,Double) -> (Double,Double) -> Double
  }
                                    