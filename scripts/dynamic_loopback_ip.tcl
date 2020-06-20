# dynamic_loopback_ip.tcl
#
#   There is no mechanism for dynamic IP address assignment on a loopback interface
#   on a Cisco IOS-XE device. This script assumes that a non-specific IP is required
#   and uses heuristic methods to assign an IP address to the loopback.
#
#   License: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#
#   Version: 1.0

# Specifies the range of available host addresses used for assignment.
set MIN_IP 2
set MAX_IP 254
# Specifies network and subnet/CIDR used for validation and assignment.
set NETWORK 198.18.0.
set CIDR /32
set NETMASK 255.255.255.255
# The BGP hub that the spoke router is connected to.
set BGP_NEIGHBOR 169.254.0.1
# Generate a random host address to be checked and/or used for IP address.
proc randomNumberRange { min max } {
    return [expr int(rand() * ($max - $min)) + $min]
}
set host [randomNumberRange $MIN_IP $MAX_IP]
# Concatenate proposed IP address in CIDR formate for BGP route check.
set loopback_cidr $NETWORK$host$CIDR
# Retrieve current BGP routes received from BGP hub router.
set bgp_routes [exec "show ip bgp neighbor $BGP_NEIGHBOR routes"]
# Retrieve current running config on loopback1
set loopback_run [exec "show run int loopback1"]

# Assumes BGP adjacency is formed/checked and loops infinitely until an IP is assigned.
while { 1 } {
    if{ ![regexp "no ip address" $loopback_run] } {
        # If an IP address is present avoid reassigning IP unnecessarily and terminate loop.
        break
    } elseif { [regexp "Total number of prefixes 0" $bgp_routes] } {
        # If NLRI has not yet propagated continue through the loop.
        continue
    } elseif { [regexp "$loopback_cidr" $bgp_routes] } {
        # If there is an existing advertisement with this IP, select another.
        set ip [randomNumberRange $MIN_IP $MAX_IP]
        set loopback_cidr $NETWORK$ip$CIDR
        continue
    } else {
        # Once the IP has pasted validation checks, assign to loopback and terminate loop.
        ios_config "interface Loopback1" "ip address $NETWORK$host $NETMASK" "end"
        break
    }
}
