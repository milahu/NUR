{ python3Packages }:

python3Packages.toPythonApplication (
  python3Packages.busylight-for-humans.overridePythonAttrs (busylight-for-humans: {
    pname = "busyserve";

    dependencies = busylight-for-humans.dependencies ++ busylight-for-humans.optional-dependencies.webapi;

    meta = busylight-for-humans.meta // {
      mainProgram = "busyserve";
    };
  })
)
