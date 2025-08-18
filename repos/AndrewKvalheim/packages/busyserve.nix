{ python3Packages }:

python3Packages.toPythonApplication (
  python3Packages.busylight-for-humans.overridePythonAttrs (busylight-for-humans: {
    pname = "busyserve";

    # Pending NixOS/nixpkgs#433998
    dependencies = busylight-for-humans.dependencies ++ (with python3Packages; [
      fastapi
      uvicorn
    ]);

    meta = busylight-for-humans.meta // {
      mainProgram = "busyserve";
    };
  })
)
