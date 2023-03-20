from typing import Optional


class NurError(Exception):
    pass


class EvalError(NurError):
    def __init__(self, message: str, stdout: Optional[str]):
        super().__init__(message)
        self.stdout = stdout or None
