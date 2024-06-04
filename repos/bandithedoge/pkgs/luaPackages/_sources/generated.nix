# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  bling = {
    pname = "bling";
    version = "19ccfc0daf5edda8bbc508487616d00277a9d954";
    src = fetchgit {
      url = "https://github.com/blingcorp/bling";
      rev = "19ccfc0daf5edda8bbc508487616d00277a9d954";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-6NZSUb7sSBUegSIPIubQUOZG3knzXfnyfEbCoEyggtc=";
    };
    date = "2024-06-02";
  };
  lua-dbus = {
    pname = "lua-dbus";
    version = "cdef26d09aa61d7f1f175675040383f6ae0becbb";
    src = fetchgit {
      url = "https://github.com/dodo/lua-dbus";
      rev = "cdef26d09aa61d7f1f175675040383f6ae0becbb";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-S+W6QTqv4kdyR86GCyDLnkml10dO4ZVNXEd3/7vDFGE=";
    };
    date = "2015-04-22";
  };
  lua-dbus_proxy = {
    pname = "lua-dbus_proxy";
    version = "cf196564a0db5fb55c8913a7faafbe69f0b45fdf";
    src = fetchgit {
      url = "https://github.com/stefano-m/lua-dbus_proxy";
      rev = "cf196564a0db5fb55c8913a7faafbe69f0b45fdf";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-tY0/7RvCtTMXNYubpxEuNd918f3kwKgb+mQK2bG0r1Q=";
    };
    date = "2022-12-09";
  };
}
