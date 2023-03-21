from typing import Optional


class NurError(Exception):
    pass


class SubprocessError(NurError):
    def __init__(self, message: str, stdout: Optional[str] = None):
        super().__init__(message)
        self.stdout = stdout or None


class EvalError(SubprocessError):
    pass


class RepoNotFoundError(NurError):
    pass
