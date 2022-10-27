if "x%VCPKG_ROOT%" NEQ "x" goto :vcpkgroot

:findvcpkg
if exist "..\vcpkg\vcpkg.exe" (set VCPKG=%CD%\..\vcpkg\vcpkg.exe && goto :install)

:novcpkg
echo "Cannot find vcpkg in this computer"
goto :eof

:vcpkgroot
set VCPKG=%VCPKG_ROOT%\vcpkg.exe
goto :install

:install
%VCPKG% install --overlay-ports=.\ports %1 %2 %3 %4 %5
