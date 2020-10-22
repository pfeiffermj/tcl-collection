# rand_dhcp_client_id.tcl
#
#   This script is designed to provide a pseudorandom unique client
#   identifier for DHCP address assignment. This solution aids in
#   dynamic IP allocation for cloned devices that are not guaranteed
#   to have a unique MAC address.
#
#   License: GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
#
#   Version: 1.0

set INTERFACE Tunnel1

# This script creates a pseudorandom 24 character string for DHCP clientId
proc lpick L {lindex $L [expr {int(rand()*[llength $L])}]}
proc randomlyPicked { length {chars {A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 0 1 2 3 4 5 6 7 8 9}} } {
    for {set i 0} {$i<$length} {incr i} {append res [lpick $chars]}
    return $res
}
set clientId [randomlyPicked 24]

ios_config "interface $INTERFACE" "ip dhcp client client-id ascii $clientId" "no shut" "end"