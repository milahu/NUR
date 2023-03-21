import ctypes
import ctypes.util
import signal

libc_path = ctypes.util.find_library("c")
libc = ctypes.CDLL(libc_path, use_errno=True)

# https://github.com/cptpcrd/pyprctl/blob/master/pyprctl/misc.py#L192
def prctl_set_pdeathsig(sig=signal.SIGKILL):
    """
        Kill child process on exit of parent process,
        to avoid zombie processes.
        sig=signal.SIGTERM is more polite, but can fail.
        Linux only.
    """
    PR_SET_PDEATHSIG = 1
    return libc.prctl(PR_SET_PDEATHSIG, sig)
