#
# A powershell script for automatically looping over all perforce helix stream depots and 
# calling 'p4 sync' on each one to sync the latest files to the local workspace. 
# If a new stream depot is detected, the script also creates a new workspace and 
# local directory for the stream depot to get synced to.
#

# Root directory for all of the workspaces on the TEC-FXP machine
$root_dir = "E:\Perforce"

# Get all of the stream depots
$streams = p4 streams

# Loop over all of the stream depots and sync them to the local workspace
foreach ($stream in $streams)
{
    # Parse out the full stream name (e.g. //VXTT/Main)
    $full_stream_name = $stream.Split(' ')[1]
    
    # Parse out just the depot name (e.g. VXTT)
    $depot_name = $full_stream_name.Split('//')[2]
    
    # Parse out just the stream name (e.g. Main)
    $short_stream_name = $full_stream_name.Split('//')[3]
   
    # Create full workspace name (e.g. VXTT-Main-TEC-FXP)
    $workspace_name = $depot_name + "-" + $short_stream_name + "-TEC-FXP"
    
    # Use a filter (e.g. p4 clients -e *VXTT-Main-TEC-FXP) to search all of the perforce workspaces 
    # to see if a workspace for this stream already exists on this machine
    $workspace_list = p4 clients -e "*${workspace_name}"

    # Get the path of the workspace root directory on this machine (e.g. E:\Perforce\VXTT-Main-TEC-FXP)
    $workspace_dir = "${root_dir}\${workspace_name}"

    # Check the filtered workspace list to see if the workspace already exists,
    # and if not, create the local workspace directory and the workspace itself
    if ($workspace_list.Count -eq 0)
    {
        # Test to see if workspace directory exists, 
        # and if not, create it, switch into it, and create the workspace
        if (-Not (Test-Path -Path $workspace_dir))
        {
            # Create the directory
            mkdir $workspace_dir

            # Switch into the directory
            Set-Location -Path $workspace_dir -PassThru

            # Create the workspace spec file without opening an editor
            p4 client -S "${full_stream_name}" -o "${workspace_name}" | p4 client -i 
        }
    }

    # Run p4 sync
    p4 -c "${workspace_name}" sync
}
