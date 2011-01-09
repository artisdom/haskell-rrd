module RRD.Misc where
import Bindings.Librrd
import Foreign.C.String (withCString)
import Control.Exception (bracket)
import Foreign.Marshal.Utils (with)
import Foreign.C.Error (throwErrnoIf_)
import Foreign.Marshal (malloc, free)
import Foreign.Storable (peek)


-- TODO make sure it's leak free, it's probably so, but it's better to make some actuall tests
lastUpdate :: FilePath -> IO Int
lastUpdate path =
    withCString path $ \c'path ->
        bracket malloc free $ \lastUpdate_ret ->
            bracket malloc free $ \dsCount_ret ->
                bracket malloc free $ \dsNames_ret ->
                    bracket malloc free $ \lastDs_ret -> do
                        throwErrnoIf_ (/=0) ("rrd " ++ show path)
                            (c'rrd_lastupdate_r c'path lastUpdate_ret dsCount_ret dsNames_ret lastDs_ret)
                        fromEnum `fmap` peek lastUpdate_ret




