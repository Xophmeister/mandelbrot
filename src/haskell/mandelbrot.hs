module Main where
import System.Environment (getArgs)
import Data.Complex
import Data.List.Split (chunksOf)
import Text.Read (readMaybe)
import Data.Maybe (isJust)

type Point = Complex Double
data MandelbrotPoint = MandelbrotPoint Int {-n-} Point {-z_n-} Point {-c-}

instance Show MandelbrotPoint where
  show (MandelbrotPoint n _ _)
    | n == 100  = " "
    | n > 10    = "#"
    | otherwise = [".',;\"oO%8@" !! (n - 1)]

data Mandelbrot = Mandelbrot [MandelbrotPoint] {-state-} Int {-width-}

instance Show Mandelbrot where
  show (Mandelbrot state width) = 
    unlines $ chunksOf width $ concatMap show state

data Arguments = Arguments Point {-topleft-} Point {-bottomright-} Int {-width-} Int {-height-}

main :: IO ()
main = do
  args <- getArgs
  putStr $ show $ mandelbrot 100 $ initialise $ parseArguments args

usage :: IO ()
usage = do
  putStrLn "Usage: mandelbrot [TOPLEFT BOTTOMRIGHT WIDTH HEIGHT]" 
  putStrLn "  TOPLEFT      Top-left corner of complex subplane" 
  putStrLn "  BOTTOMRIGHT  Bottom-right corner of complex subplane"
  putStrLn "  WIDTH        Output width (characters)"
  putStrLn "  HEIGHT       Output height (characters)"

parseArguments :: [String] -> Arguments
parseArguments [topLeft, bottomRight, width, height] =
  if (all isJust planeCoords) && (all isJust imageCoords)
    -- TODO Sanity check values
    then Arguments (read topLeft) (read bottomRight) (read width) (read height)
    else error "Bad arguments" -- TODO: Print usage and exit 1
  where planeCoords = map readMaybe [topLeft, bottomRight] :: [Maybe Point]
        imageCoords = map readMaybe [width, height]        :: [Maybe Int]

-- Default values
parseArguments _ = Arguments ((-2) :+ 1) (1 :+ (-1)) 99 33

initialise :: Arguments -> Mandelbrot
initialise (Arguments topLeft bottomRight width height) =
  Mandelbrot (map (MandelbrotPoint 0 0) field) width
  where [w, h]    = map fromIntegral [width, height]
        diagonal  = bottomRight - topLeft
        scaleReal = realPart diagonal / (w - 1)
        scaleImag = imagPart diagonal / (h - 1)
        field     = [ ((x * scaleReal) :+ (y * scaleImag)) + topLeft
                    | y <- [0..(h - 1)], x <- [0..(w - 1)]]

mandelbrot :: Int -> Mandelbrot -> Mandelbrot
mandelbrot 0 state = state
mandelbrot x (Mandelbrot state width) = 
  mandelbrot (x - 1) (Mandelbrot (map step state) width)
    where step point@(MandelbrotPoint n z_n c)
            | magnitude z_n > 2 = point
            | otherwise         = MandelbrotPoint (n + 1) ((z_n * z_n) + c) c
