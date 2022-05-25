# DevOps
Compilation of scripts and in-house tools we've made for our infrastructure.

## p4

[perforce_sync_stream_depots.ps1](https://github.com/theexperiential/DevOps/blob/main/p4/perforce_sync_stream_depots.ps1)

A powershell script for automatically looping over all perforce helix stream depots and calling 'p4 sync' on each one to sync the latest files to the local workspace. If a new stream depot is detected, the script also creates a new workspace and local directory for the stream depot to get synced to.
