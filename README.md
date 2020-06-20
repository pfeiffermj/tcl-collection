# tcl-collection

A collection of TCL scripts

## dynamic_loopback_ip.tcl

There is no mechanism for dynamic IP address assignment on a loopback interface on a Cisco IOS-XE device. This script assumes that a non-specific IP is required and uses heuristic methods to assign an IP address to the loopback.

### Example Usage

The tcl script must exist on the router for it to be used. This can be accomplished by transferring the file to the router several ways (e.g. SCP, TFTP, FTP) or creating it using local tclsh commands. Below is a configuration example on creating a file locally on the router using tclsh.

```shell
tclsh
puts [ open "bootflash:dynamic_loopback_ip.tcl" w+] {
    ...
}
```

Once the tcl script is stored in the router’s bootflash, an event manager applet can be created to call the script based on an event. In the example below, the EEM applet will be invoked once a specific BGP neighbor adjacency is formed. The tcl script will run and the resulting configuration is saved.

```shell
enable
config t
!
event manager applet on_bgp_adj
 event syslog pattern "%BGP-5-ADJCHANGE: neighbor 169.254.0.1 Up"
 action 1.0 cli command "enable"
 action 2.0 cli command "tclsh bootflash:dynamic_loopback_ip.tcl"
 action 3.0 cli command "wr mem"
!
end
wr mem
```