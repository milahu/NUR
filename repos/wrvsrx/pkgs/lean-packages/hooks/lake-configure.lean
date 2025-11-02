import Lake.Load.Manifest
import Lean.Data.Json
import Lean.Data.Json.FromToJson

structure ManifestOverride where
  name: Lean.Name
  dir: System.FilePath
  deriving Lean.ToJson, Lean.FromJson, Inhabited

example (l : Lean.Name) (r : Lean.Name) : Bool := l == r

def overrideManifest (manifestOverrides : Array ManifestOverride) (manifest : Lake.Manifest) : Lake.Manifest :=
  let packagesOverrided :=
    manifest.packages.map (
      fun packageEntry =>
        let optionOverride := manifestOverrides.find? (fun manifestOverride => manifestOverride.name == packageEntry.name) 
        match optionOverride with
          | some x => {packageEntry with src := Lake.PackageEntrySrc.path x.dir} 
          | none => packageEntry
    )
  {manifest with packages := packagesOverrided}

def patchManifest : IO Unit := do
  let manifestString ← IO.FS.readFile "lake-manifest.json"
  let manifestParseResult : Except String Lake.Manifest := do
    let x ← Lean.Json.parse manifestString
    Lean.FromJson.fromJson? x
  let manifest ← match manifestParseResult with
    | Except.ok x => pure x
    | Except.error x => throw (IO.Error.userError x)

  let manifestOverridePath  ← IO.getEnv "NIX_LAKE_MANIFEST_OVERRIDE" >>= (pure ∘ System.FilePath.mk ∘  Option.get!)
  let manifestOverrideString ← IO.FS.readFile manifestOverridePath
  let manifestOverrideParseResult : Except String (Array ManifestOverride) := do
    let x ← Lean.Json.parse manifestOverrideString
    Lean.FromJson.fromJson? x
  let manifestOverride ← match manifestOverrideParseResult with
    | Except.ok x => pure x
    | Except.error x => throw (IO.Error.userError x)

  let manifestOverrided := overrideManifest manifestOverride manifest

  let manifestOverridedStr := toString (Lean.ToJson.toJson manifestOverrided) 
  IO.print manifestOverridedStr

def main : IO Unit := do
  patchManifest
