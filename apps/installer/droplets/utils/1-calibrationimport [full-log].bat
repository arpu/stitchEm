@echo off
echo Convert importing calibration %1
echo.
"%~dp0\calibrationimport" -i %1 -v 4
echo.
pause