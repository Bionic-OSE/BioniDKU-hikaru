# Hikaru-chan post-update script - (c) Bionic Butter
# This file contains commands that will be run after you update from an older release to the current release, and will be changed for be empty depending on each releases

Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "ProductName" -Value "BioniDKU" -Type String -Force