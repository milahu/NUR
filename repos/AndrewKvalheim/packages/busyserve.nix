{ python3Packages }:

python3Packages.toPythonApplication (
  python3Packages.busylight-for-humans.overridePythonAttrs (busylight-for-humans: {
    pname = "busyserve";

    # TODO: Upstream as optional-dependencies
    dependencies = busylight-for-humans.dependencies ++ (with python3Packages; [
      fastapi
      uvicorn
    ]);

    meta = busylight-for-humans.meta // {
      mainProgram = "busyserve";
    };
  })
)
