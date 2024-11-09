# Get the current date and time for the filename
$dateTime = Get-Date -Format "yyyy-MM-dd_HH-mm"
$systemName = $env:COMPUTERNAME  # Get the system name (hostname)
$outputDir = $PSScriptRoot  # Use the directory where the script is located

# List available interfaces
$interfaces = pktmon list

# Display the available interfaces
Write-Host "Available Interfaces:"
$interfaces | ForEach-Object {
    Write-Host $_
}

# Prompt the user to select an interface
$interfaceNumber = Read-Host "Enter the number of the interface to use"

# Start packet capture with specific options, replacing '73' with the selected interface
Write-Host "Starting packet capture on interface number $interfaceNumber..."
pktmon start -c --comp $interfaceNumber --pkt-size 0
Write-Host "Packet capture started. Press any key to stop..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Stop packet capture
pktmon stop
Write-Host "Packet capture stopped."

# Convert to PCAPNG format
$outputFileName = "$systemName-$dateTime.pcapng"
Write-Host "Converting to PCAPNG format..."
pktmon etl2pcap "$outputDir\PktMon.etl" -o "$outputDir\$outputFileName"

Write-Host "Capture saved as $outputFileName"